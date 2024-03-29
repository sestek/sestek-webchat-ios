//
//  AttachmentImageTableViewCell.swift
//  sestek-webchat-ios
//
//  Created by Tolga Taner on 2.06.2023.
//

import UIKit

class AttachmentImageTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var attachmentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func updateCell(_ url: String) {
        attachmentImageView.setImage(with: url)
    }
}
