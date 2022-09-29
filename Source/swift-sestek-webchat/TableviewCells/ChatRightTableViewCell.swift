//
//  ChatRightTableViewCell.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 20.07.2022.
//

import UIKit

final class ChatRightTableViewCell: UITableViewCell {

    @IBOutlet private weak var labelDescription: UILabel! {
        didSet {
            labelDescription.textColor = CustomConfiguration.config.messageColor
        }
    }
    @IBOutlet private weak var labelUser: UILabel! {
        didSet {
            labelUser.text = CustomConfiguration.config.incomingText
            labelUser.textColor = CustomConfiguration.config.incomingTextColor
        }
    }
    @IBOutlet private weak var labelTime: UILabel!
    @IBOutlet private weak var viewContent: UIView! {
        didSet {
            viewContent.clipsToBounds = true
            viewContent.layer.cornerRadius = 10
            viewContent.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
            viewContent.makeShadow()
            viewContent.backgroundColor = CustomConfiguration.config.messageBoxColor
        }
    }
    @IBOutlet private weak var ivUser: UIImageView! {
        didSet {
            switch CustomConfiguration.config.incomingIcon {
            case .image(let image):
                ivUser.image = image
            case .url(let url):
                ivUser.setImage(with: url)
            default:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(data: ChatModel) {
        let textLanguage = TextHelper().getTextLanguage(data.text)
        labelDescription.text = data.text
        labelDescription.semanticContentAttribute = textLanguage?.semanticContentAttribute ?? .forceLeftToRight
        labelUser.text = CustomConfiguration.config.incomingText
        labelTime.text = Date().getAsString(.yyyyMMddHHmm)
    }
}
