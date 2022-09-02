//
//  ChatRightTableViewCell.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 20.07.2022.
//

import UIKit

final class ChatRightTableViewCell: UITableViewCell {

    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak private var viewContent: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            viewContent.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
        
        viewContent.makeShadow()
    }
    
    func updateCell(data: ChatModel) {
        let textLanguage = TextHelper().getTextLanguage(data.text)
        lblTitle.text = data.text
        lblTitle.semanticContentAttribute = textLanguage?.semanticContentAttribute ?? .forceLeftToRight
        lblUser.text = SignalRConnectionManager.sharedInstance.connectionInfo?.fullName ?? ""
        lblTime.text = Date().getAsString(.yyyyMMddHHmm)
    }
}
