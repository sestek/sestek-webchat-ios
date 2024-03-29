//
//  AttachmentCollectionViewCell.swift
//  sestek-webchat-ios
//
//  Created by Tolga Taner on 24.05.2023.
//

import UIKit
protocol AttachmentCollectionViewCellDelegate: AnyObject {
    func onButtonClicked(value: String)
}
class AttachmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    weak var delegate: AttachmentCollectionViewCellDelegate?
    private var attachment: AttachmentResponseModel?
    private var maxButtonHeight: CGFloat = .zero
    private var cellHeight: CGFloat = .zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: ImageCollectionViewCell.self)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
    }
    
    private func setLabel(text: String?, content: UILabel) {
        content.text = text
        content.font = .systemFont(ofSize: 13, weight: .regular)
        content.textColor = CustomConfiguration.config.messageColor
        content.backgroundColor = .clear
        if let language = TextHelper().getTextLanguage(text) {
            content.textAlignment = language.textAlignment
            content.semanticContentAttribute = language.semanticContentAttribute
        } else {
            content.textAlignment = .center
            content.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    func updateCell(_ attachment: AttachmentResponseModel, height: CGFloat, maxButtonHeight: CGFloat, delegate: AttachmentCollectionViewCellDelegate) {
        self.delegate = delegate
        self.cellHeight = height
        self.maxButtonHeight = maxButtonHeight
        self.attachment = attachment
        setLabel(text: attachment.content?.title, content: titleLabel)
        setLabel(text: attachment.content?.subtitle ?? attachment.content?.text, content: subTitleLabel)
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        collectionViewHeight.constant = height
        collectionView.reloadData()
    }
}
extension AttachmentCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell {
            if let attachment = attachment,
               let content = attachment.content {
                let imageUrl = content.images?.compactMap{ $0.url }
                cell.updateCell(imageUrl, buttonResponse: content.buttons, maxHeight: maxButtonHeight, delegate: self)
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: maxButtonHeight + CGFloat(100 * (attachment?.content?.images?.count ?? 0)) + 10)
    }
}
extension AttachmentCollectionViewCell: ImageCollectionViewCellDelegate {
    func onButtonClicked(value: String) {
        delegate?.onButtonClicked(value: value)
    }
}
