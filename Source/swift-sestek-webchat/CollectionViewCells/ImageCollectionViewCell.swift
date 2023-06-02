//
//  ImageCollectionViewCell.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 19.08.2022.
//

import UIKit
protocol ImageCollectionViewCellDelegate: AnyObject {
    func onButtonClicked(value: String)
}

class ImageCollectionViewCell: UICollectionViewCell {

    weak var delegate: ImageCollectionViewCellDelegate?
    
    @IBOutlet private weak var buttonsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var buttonsCollectionView: UICollectionView!
    @IBOutlet private weak var imageView: UIImageView!
    var buttonResponse: [ButtonResponseModel]? = nil
    var maxHeight: CGFloat = .zero
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonsCollectionView.register(cell: ButtonCollectionViewCell.self)
        buttonsCollectionView.delegate = self
        buttonsCollectionView.dataSource = self
    }
    
    private struct Constant {
        static let buttonHeight: CGFloat = 40
        static let eachButtonSpacing: CGFloat = 10
        static let buttonsToBottomHeight: CGFloat = 10
    }
    
    func updateCell(imageUrl: String?, buttonResponse: [ButtonResponseModel]?, maxHeight: CGFloat, delegate: ImageCollectionViewCellDelegate) {
        self.delegate = delegate
        self.maxHeight = maxHeight
        self.buttonResponse = buttonResponse
        if let imageUrl = imageUrl {
            imageView.setImage(with: imageUrl) {}
        }
        buttonsCollectionViewHeight.constant = maxHeight + Constant.buttonsToBottomHeight
        buttonsCollectionView.reloadData()
    }
}
extension ImageCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as? ButtonCollectionViewCell {
            if let response = buttonResponse?[indexPath.row] {
                cell.updateCell(response, delegate: self)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        buttonResponse?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Constant.buttonHeight + Constant.eachButtonSpacing)
    }
}
extension ImageCollectionViewCell: ButtonCollectionViewCellDelegate {
    func onButtonClicked(value: String) {
        delegate?.onButtonClicked(value: value)
    }
}
