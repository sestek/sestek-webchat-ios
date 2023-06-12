//
//  ButtonCollectionViewCell.swift
//  sestek-webchat-ios
//
//  Created by Tolga Taner on 2.06.2023.
//

import UIKit

protocol ButtonCollectionViewCellDelegate: AnyObject {
    func onButtonClicked(value: String)
}

class ButtonCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var actionButton: CustomButton!
    weak var delegate: ButtonCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(_ buttonResponse: ButtonResponseModel, delegate: ButtonCollectionViewCellDelegate) {
        self.delegate = delegate
        actionButton.titleText = buttonResponse.title ?? String()
        actionButton.value = buttonResponse.value ?? ""
    }
    
    @IBAction private func actionButtonDidTapped(_ sender: CustomButton) {
        delegate?.onButtonClicked(value: sender.value ?? "")
    }
    
}
