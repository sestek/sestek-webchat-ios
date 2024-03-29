//
//  ChatViewController.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 19.07.2022.
//

import AVKit
import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak private var btnSend: UIButton!
    @IBOutlet weak private var btnMic: UIButton! {
        didSet {
            btnMic.isHidden = !SignalRConnectionManager.shared.isVoiceRecordingEnabled
        }
    }
    @IBOutlet weak private var tfMessage: UITextField! {
        didSet {
            tfMessage.attributedPlaceholder = NSAttributedString(
                string: CustomConfiguration.config.bottomInputText,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
            tfMessage.textColor = CustomConfiguration.config.bottomColor
        }
    }
    @IBOutlet weak private var viewBottom: UIView! {
        didSet {
            viewBottom.makeShadow()
            viewBottom.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.register(cell: ChatLeftTableViewCell.self)
            tableView.register(cell: ChatRightTableViewCell.self)
            setTableView()
            tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTableViewClicked(_:))))
        }
    }
    @IBOutlet private weak var backgroundImage: UIImageView! {
        didSet {
            backgroundImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            backgroundImage.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var labelTitle: UILabel! {
        didSet {
            labelTitle.text = CustomConfiguration.config.headerText
        }
    }
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    
    private var tableViewSource: ChatTableViewSource?
    private var isVoiceRecording: Bool = false
    private var recordedFileURL: URL?
    private var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignalRConnectionManager.shared.messagingDelegate = self
        configure()
        observeKeyboardEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardEvents()
    }
    
    @IBAction private func onButtonSendClicked(_ sender: Any) {
        if !(tfMessage.text?.replacingOccurrences(of: " ", with: "").isEmpty ?? false) {
            sendMessage(message: tfMessage.text ?? "")
        }
    }
    
    @IBAction private func onButtonMicClicked(_ sender: Any) {
        isVoiceRecording.toggle()
        btnMic.tintColor = isVoiceRecording ? .red : .black
        isVoiceRecording ? startRecorder() : stopRecorder()
    }
    
    @IBAction private func onButtonHideClicked(_ sender: Any) {
        FloatingRoundedButtonController.sharedInstance.updatePopoverVisibility(to: .closed)
    }
    
    @IBAction private func onButtonCloseClicked(_ sender: Any) {
        SignalRConnectionManager.shared.endConversation { [weak self] in
            FloatingRoundedButtonController.sharedInstance.updatePopoverVisibility(to: .closed)
            self?.setTableView()
        } onError: { [weak self] error in
            self?.showStandardAlert(message: error)
        }
    }
}

fileprivate extension ChatViewController {
    func configure() {
        setBodyImage()
    }
    
    
    func setTableView() {
        if tableViewSource == nil {
            tableViewSource = ChatTableViewSource(items: SignalRConnectionManager.shared.chat, delegate: self, sourceDelegate: self)
            tableView.dataSource = tableViewSource
            tableView.delegate = tableViewSource
        } else {
            tableViewSource?.items = SignalRConnectionManager.shared.chat
        }
        
        tableView.reloadData()
        scrollToBottom()
    }
    
    func sendMessage(message: String, isSoundMessage: Bool = false) {
        if !isSoundMessage {
            setOwnerMessage(message: message)
        }
        SignalRConnectionManager.shared.sendMessage(message: message) { [weak self] in
            guard let self = self else { return }
            self.tfMessage.text = ""
        } onError: { [weak self] error in
            self?.showStandardAlert(message: error)
        }
    }
    
    func setOwnerMessage(message: String) {
        SignalRConnectionManager.shared.chat.append(ChatModel(text: message, attachment: nil, isOwner: true, date: nil, layout: .unknown))
        setTableView()
    }
    
    func setOwnerMessage(recordedFileUrl: URL?) {
        SignalRConnectionManager.shared.chat.append(ChatModel(text: "", isOwner: true, layout: .unknown, recordedFileURL: recordedFileUrl))
        setTableView()
    }
    
    func scrollToBottom() {
        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections - 1)
        if numberOfSections > 0 && numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1 , section: numberOfSections - 1)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func setBodyImage() {
        switch CustomConfiguration.config.bodyColorOrImage {
        case .image(let image):
            backgroundImage.image = image
        case .url(let url):
            backgroundImage.setImage(with: url)
        case .color(let color):
            backgroundImage.image = UIImage()
            backgroundImage.backgroundColor = color
        }
    }
    
    @objc func onTableViewClicked(_ sender: UITapGestureRecognizer?) {
        tfMessage.endEditing(true)
    }
}

// MARK: - Messaging Delegate
extension ChatViewController: SignalRConnectionManagerMessagingDelegate {
    func onNewMessageReceived(messageDetail: MessageDetailResponseModel?) {
        let geoModel = messageDetail?.entities?.first??.geo ?? nil
        var model: ChatModel!
        if let attachments = messageDetail?.attachments, attachments.count > 0 {
            // for carousel layouts
            model = ChatModel(text: messageDetail?.text ?? "", attachment: attachments, isOwner: false, date: messageDetail?.timestamp ?? "", layout: .carousel, location: geoModel)
            SignalRConnectionManager.shared.chat.append(model)
        } else {
            model = ChatModel(text: messageDetail?.text ?? "", attachment: nil, isOwner: false, date: messageDetail?.timestamp ?? "", layout: .unknown, location: geoModel)
            SignalRConnectionManager.shared.chat.append(model)
        }
        setChatbotText(model)
    }
    
    func setChatbotText(_ model: ChatModel) {
        if tableViewSource == nil {
            tableViewSource = ChatTableViewSource(items: SignalRConnectionManager.shared.chat,
                                                  delegate: self, sourceDelegate: self)
            tableView.dataSource = tableViewSource
            tableView.delegate = tableViewSource
            tableViewSource?.loadChatbotContents()
        } else {
            tableViewSource?.append(chat: model)
        }
    }
    
    func onError(error: String?) {
        tfMessage.text = ""
        showStandardAlert(message: error)
    }
}

// MARK: - TableViewCell Delegate
extension ChatViewController: ChatTableViewCellDelegate {
    func onButtonClicked(value: String) {
        sendMessage(message: value)
    }
    
    func onLinkClicked(with url: URL) {
        openSFSafariViewController(with: url)
    }
    
    func onMapCliked(latitude: Double, longitude: Double) {
        let installedMaps = MapUtil.shared.getInstalledMaps()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        installedMaps.forEach { item in
            alert.addAction(UIAlertAction(title: item.mapName, style: .default, handler: { _ in
                MapUtil.shared.onMapSelected(selectedMap: item, latitude: latitude, longitude: longitude)
            }))
        }
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

// MARK: - Voice Recorder
fileprivate extension ChatViewController {
    func startRecorder() {
        let session = AVAudioSession.sharedInstance()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        } catch {
            print(error.localizedDescription)
        }
        
        session.requestRecordPermission { hasPermission in
            if hasPermission {
                self.recordedFileURL = self.getDirectory().appendingPathComponent("\(UUID().uuidString).m4a")
                guard let fileURL = self.recordedFileURL else {
                    print("File URL is not correct")
                    return
                }
                let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                              AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                     AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
                
                do {
                    self.audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
                    self.audioRecorder?.delegate = self
                    self.audioRecorder?.record()
                } catch {
                    print("Recording failed")
                }
                
            } else {
                print("No permission")
            }
        }
    }
    
    func stopRecorder() {
        guard let _ = self.audioRecorder else {
            print("Recorder not found")
            return
        }
        audioRecorder?.stop()
        audioRecorder = nil
        setOwnerMessage(recordedFileUrl: recordedFileURL)
        uploadVoice(recordedFileUrl: recordedFileURL)
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func uploadVoice(recordedFileUrl: URL?) {
        Services.shared.uploadVoice(recordedFileURL: recordedFileUrl, sessionId: SignalRConnectionManager.shared.conversationId, project: DefaultConfiguration.config?.project, clientId: DefaultConfiguration.config?.clientId, tenant: DefaultConfiguration.config?.tenant, fullName: DefaultConfiguration.config?.fullName, customAction: "startOfConversation", customActionData: "startOfConversation") { jsonObject in
            self.sendMessage(message: jsonObject ?? "", isSoundMessage: true)
        } onError: { error in
            self.showStandardAlert(message: error)
        }
    }
}

extension ChatViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            self.showStandardAlert(message: "Recording is stoppped")
        }
    }
}

extension ChatViewController: ChatTableViewSourceDelegate {
    func reloadTableView() {
        tableView.reloadData()
        self.scrollToBottom()
    }
}

fileprivate extension ChatViewController {
    func observeKeyboardEvents() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let keyboardHeight = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            let duration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            let bottomSafeArea = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self?.constraintBottom.constant = keyboardHeight.height - bottomSafeArea },
                           completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] (notification) in
            let duration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self?.constraintBottom.constant = 0 },
                           completion: nil)
        }
    }
    
    func removeKeyboardEvents() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
}
