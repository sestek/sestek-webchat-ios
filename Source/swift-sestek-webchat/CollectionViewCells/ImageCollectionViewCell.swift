//
//  ImageCollectionViewCell.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 19.08.2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(imageUrl: String?) {
        imageView.setImage(with: imageUrl)
    }

}
