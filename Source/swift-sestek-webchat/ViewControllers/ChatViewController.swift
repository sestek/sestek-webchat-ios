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
                string: "Write smt",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
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
    
    var bgColor: UIColor?
    private var tableViewSource: ChatTableViewSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignalRConnectionManager.sharedInstance.messagingDelegate = self
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FloatingRoundedButtonController.sharedInstance.hideButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        FloatingRoundedButtonController.sharedInstance.showButton()
    }
    
    @IBAction private func onButtonSendClicked(_ sender: Any) {
        if !(tfMessage.text?.replacingOccurrences(of: " ", with: "").isEmpty ?? false) {
            sendMessage(message: tfMessage.text ?? "")
        }
    }
    
    @IBAction func onButtonMicClicked(_ sender: Any) {
    }
    
    @objc private func didTapBtnClose() {
        dismiss(animated: true)
    }
}

fileprivate extension ChatViewController {
    func configure() {
        if let bgColor = bgColor {
            view.backgroundColor = bgColor
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(didTapBtnClose))
    }
    
    func setTableView() {
        tableViewSource = ChatTableViewSource(items: SignalRConnectionManager.sharedInstance.chat, delegate: self)
        tableView.dataSource = tableViewSource
        tableView.delegate = tableViewSource
        tableView.reloadData()
        scrollToBottom()
    }
    
    func sendMessage(message: String) {
        setOwnerMessage(message: message)
        SignalRConnectionManager.sharedInstance.sendMessage(message: message) { [weak self] in
            guard let self = self else { return }
            self.tfMessage.text = ""
        } onError: { [weak self] error in
            self?.showStandardAlert(message: error)
        }
    }
    
    func setOwnerMessage(message: String) {
        SignalRConnectionManager.sharedInstance.chat.append(ChatModel(text: message, attachment: nil, isOwner: true, date: nil))
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
}

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
                    SignalRConnectionManager.sharedInstance.chat.append(ChatModel(text: messageDetail?.text ?? "", attachment: attachment, isOwner: false, date: messageDetail?.timestamp ?? ""))
                }
            } else { // for other layouts
                attachments.forEach { attachment in
                    SignalRConnectionManager.sharedInstance.chat.append(ChatModel(text: messageDetail?.text ?? "", attachment: attachment, isOwner: false, date: messageDetail?.timestamp ?? ""))
                }
            }
        } else {
            SignalRConnectionManager.sharedInstance.chat.append(ChatModel(text: messageDetail?.text ?? "", attachment: nil, isOwner: false, date: messageDetail?.timestamp ?? ""))
        }
        setTableView()
    }
    
    func onError(error: String?) {
        showStandardAlert(message: error)
    }
}

extension ChatViewController: ChatTableViewCellDelegate {
    func onButtonClicked(value: String) {
        sendMessage(message: value)
    }
    
    func onLinkClicked(with url: URL) {
        openSFSafariViewController(with: url)
    }
}
