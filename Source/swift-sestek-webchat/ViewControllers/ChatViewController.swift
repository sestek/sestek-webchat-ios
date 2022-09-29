//
//  ChatViewController.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 19.07.2022.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak private var btnSend: UIButton!
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
        }
    }
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.register(cell: ChatLeftTableViewCell.self)
            tableView.register(cell: ChatRightTableViewCell.self)
            setTableView()
        }
    }
    @IBOutlet private weak var backgroundImage: UIImageView!
    
    private var tableViewSource: ChatTableViewSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignalRConnectionManager.shared.messagingDelegate = self
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction private func onButtonSendClicked(_ sender: Any) {
        if !(tfMessage.text?.replacingOccurrences(of: " ", with: "").isEmpty ?? false) {
            sendMessage(message: tfMessage.text ?? "")
        }
    }
    
    @IBAction private func onButtonMicClicked(_ sender: Any) {
    }
    
    @objc private func onButtonHideClicked(_ sender: Any) {
        FloatingRoundedButtonController.sharedInstance.updatePopoverVisibility(to: .closed)
    }
    
    @objc private func onButtonCloseClicked(_ sender: Any) {
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
        configureNavigationBar()
        setBodyImage()
    }
    
    func setTableView() {
        tableViewSource = ChatTableViewSource(items: SignalRConnectionManager.shared.chat, delegate: self)
        tableView.dataSource = tableViewSource
        tableView.delegate = tableViewSource
        tableView.reloadData()
        scrollToBottom()
    }
    
    func sendMessage(message: String) {
        setOwnerMessage(message: message)
        SignalRConnectionManager.shared.sendMessage(message: message) { [weak self] in
            guard let self = self else { return }
            self.tfMessage.text = ""
        } onError: { [weak self] error in
            self?.showStandardAlert(message: error)
        }
    }
    
    func setOwnerMessage(message: String) {
        SignalRConnectionManager.shared.chat.append(ChatModel(text: message, attachment: nil, isOwner: true, date: nil))
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
    
    func configureNavigationBar() {
        let buttonTitle = UIBarButtonItem(title: CustomConfiguration.config.headerText, style: .plain, target: nil, action: nil)
        let buttonHide = UIBarButtonItem.createNavigationBarButton(image: .ic_hide, target: self, action: #selector(onButtonHideClicked(_:)))
        let buttonClose = UIBarButtonItem.createNavigationBarButton(image: .ic_close, target: self, action: #selector(onButtonCloseClicked(_:)))
        navigationItem.leftBarButtonItem = buttonTitle
        navigationItem.rightBarButtonItems = [buttonClose, buttonHide]
    }
    
    func setBodyImage() {
        switch CustomConfiguration.config.bodyColorOrImage {
        case .image(let image):
            backgroundImage.isHidden = false
            backgroundImage.image = image
        case .url(let url):
            backgroundImage.isHidden = false
            backgroundImage.setImage(with: url)
        case .color(let color):
            backgroundImage.isHidden = true
            backgroundImage.image = UIImage()
            view.backgroundColor = color
        }
    }
}

// MARK: - Messaging Delegate
extension ChatViewController: SignalRConnectionManagerMessagingDelegate {
    func onNewMessageReceived(messageDetail: MessageDetailResponseModel?) {
        if let attachments = messageDetail?.attachments, attachments.count > 0 {
            // for carousel layouts
            if messageDetail?.attachmentLayout == .carousel {
                var tempAttachments = attachments
                let _ = tempAttachments.enumerated()
                    .map { (index, attachment) -> AttachmentResponseModel? in
                        if index != 0 {
                            tempAttachments[0]?.content?.images?.append(contentsOf: attachment?.content?.images ?? [])
                        }
                        return attachment
                    }
                if let attachment = tempAttachments.first {
                    SignalRConnectionManager.shared.chat.append(ChatModel(text: messageDetail?.text ?? "", attachment: attachment, isOwner: false, date: messageDetail?.timestamp ?? ""))
                }
            } else { // for other layouts
                attachments.forEach { attachment in
                    SignalRConnectionManager.shared.chat.append(ChatModel(text: messageDetail?.text ?? "", attachment: attachment, isOwner: false, date: messageDetail?.timestamp ?? ""))
                }
            }
        } else {
            SignalRConnectionManager.shared.chat.append(ChatModel(text: messageDetail?.text ?? "", attachment: nil, isOwner: false, date: messageDetail?.timestamp ?? ""))
        }
        setTableView()
    }
    
    func onError(error: String?) {
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
}
