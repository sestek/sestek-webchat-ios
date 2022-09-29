//
//  ChatTableViewSource.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 20.07.2022.
//

import UIKit

final class ChatTableViewSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    private var items: [ChatModel]
    private var delegate: ChatTableViewCellDelegate?
    
    init(items: [ChatModel], delegate: ChatTableViewCellDelegate?) {
        self.items = items
        self.delegate = delegate
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
            cell.updateCell(chat: items[indexPath.row], delegate: delegate)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
