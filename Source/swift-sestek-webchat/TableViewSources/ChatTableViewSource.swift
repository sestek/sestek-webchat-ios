//
//  ChatTableViewSource.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 20.07.2022.
//

import UIKit

protocol ChatTableViewSourceDelegate: AnyObject {
    func reloadTableView()
}

final class ChatTableViewSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var items: [ChatModel]
    private var delegate: ChatTableViewCellDelegate?
    var chatbotViewList: [ChatbotView]
    private var sourceDelegate: ChatTableViewSourceDelegate?
    private var cachedHeight: [IndexPath : CGFloat] = [:]
    
    init(items: [ChatModel],
         delegate: ChatTableViewCellDelegate?,
         sourceDelegate: ChatTableViewSourceDelegate) {
        self.items = items
        self.delegate = delegate
        self.sourceDelegate = sourceDelegate
        self.chatbotViewList = []
    }
    
    func append(chat: ChatModel) {
        items.append(chat)
        let view: ChatbotView = ChatbotView(id: chat.id, text: chat.text, delegate: self)
        chatbotViewList.append(view)
        view.load()
    }
    
    func loadChatbotContents() {
        chatbotViewList.forEach { $0.load() }
    }
    
    private func getRowOfChatbotView(fromId id: String) -> ChatbotView? {
        if let id: Int = chatbotViewList.firstIndex(where: { $0.id == id }) {
            return chatbotViewList[id]
        }
        return nil
    }
    
    private func getRow(fromChatbotView view: ChatbotView) -> Int? {
        items.firstIndex(where: { $0.id == view.id })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if items[indexPath.row].isOwner {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatRightTableViewCell.identifier, for: indexPath) as! ChatRightTableViewCell
            cell.updateCell(data: items[indexPath.row])
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatLeftTableViewCell.identifier, for: indexPath) as! ChatLeftTableViewCell
            if let content = getRowOfChatbotView(fromId: items[indexPath.row].id) {
                cell.updateCell(chat: items[indexPath.row], delegate: delegate, content: content)
            } else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if items[indexPath.row].isOwner {
            return UITableView.automaticDimension
        } else {
            if let height = cachedHeight[indexPath] {
                return height
            } else {
                cachedHeight.updateValue(UITableView.automaticDimension, forKey: indexPath)
                return UITableView.automaticDimension
            }
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
//MARK: - ChatbotViewDelegate
extension ChatTableViewSource: ChatbotViewDelegate {
    func contentDidLoad() {
        sourceDelegate?.reloadTableView()
    }
    
    func webViewDidLoad() {
        sourceDelegate?.reloadTableView()
    }
    
    func urlDidTapped(_ url: URL) {
        delegate?.onLinkClicked(with: url)
    }
}
