//
//  ChatLeftTableViewCell.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 19.08.2022.
//

import UIKit

protocol ChatTableViewCellDelegate: AnyObject {
    func onButtonClicked(value: String)
    func onLinkClicked(with url: URL)
}

class ChatLeftTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var viewRoot: UIView! {
        didSet {
            viewRoot.clipsToBounds = true
            viewRoot.layer.cornerRadius = 10
            viewRoot.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            viewRoot.makeShadow()
            viewRoot.backgroundColor = CustomConfiguration.config.messageBoxColor
        }
    }
    @IBOutlet weak var ivSender: UIImageView! {
        didSet {
            switch CustomConfiguration.config.outgoingIcon {
            case .image(let image):
                ivSender.image = image
            case .url(let url):
                ivSender.setImage(with: url)
            default:
                break
            }
        }
    }
    @IBOutlet private weak var labelSenderName: UILabel! {
        didSet {
            labelSenderName.text = CustomConfiguration.config.outgoingText
            labelSenderName.textColor = CustomConfiguration.config.outgoingTextColor
        }
    }
    @IBOutlet private weak var svRootDescriptions: UIStackView!
    @IBOutlet private weak var svRootButtons: UIStackView!
    @IBOutlet private weak var labelTime: UILabel!
    @IBOutlet private weak var svImages: UIStackView!
    @IBOutlet private weak var collectionViewImage: UICollectionView! {
        didSet {
            collectionViewImage.register(cell: ImageCollectionViewCell.self)
        }
    }
    @IBOutlet private weak var pageControlImages: UIPageControl!
    
    private weak var delegate: ChatTableViewCellDelegate?
    private var chat: ChatModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(chat: ChatModel?, delegate: ChatTableViewCellDelegate?) {
        self.delegate = delegate
        self.chat = chat
        setDefaultUI()
        setLabels(texts: TextHelper().getTextsWithAttributes(chat?.text))
        labelTime.text = (chat?.date ?? "").getDate(formatter: .yyyyMMddTHHmmssSSSSSSSZ)?.getAsString(.yyyyMMddHHmm)
        if let buttons = (chat?.attachment?.content?.buttons), buttons.count > 0 {
            svRootButtons.isHidden = false
            setButtons(buttons: chat?.attachment?.content?.buttons)
        }
        if let images = (chat?.attachment?.content?.images), images.count > 0 {
            svImages.isHidden = false
            configureImageCollectionView()
        }
    }
    
    private func setDefaultUI() {
        svRootButtons.isHidden = true
        svImages.isHidden = true
        collectionViewImage.delegate = nil
        collectionViewImage.dataSource = nil
    }
    
    private func setButtons(buttons: [ButtonResponseModel?]?) {
        svRootButtons.subviews.forEach { $0.removeFromSuperview() }
        buttons?.forEach({ buttonDetail in
            let button = CustomButton()
            button.setTitle(buttonDetail?.title ?? "", for: .normal)
            button.value = buttonDetail?.value ?? ""
            button.addTarget(self, action: #selector(onCustomButtonClicked(_:)), for: .touchUpInside)
            svRootButtons.addArrangedSubview(button)
        })
    }
    
    private func setLabels(texts: [CustomText]) {
        svRootDescriptions.subviews.forEach { $0.removeFromSuperview() }
        texts.forEach { text in
            let textView = UITextView()
            textView.dataDetectorTypes = .all
            textView.text = text.text ?? ""
            textView.font = .systemFont(ofSize: 13, weight: .semibold)
            textView.textColor = CustomConfiguration.config.messageColor
            textView.backgroundColor = .clear
            textView.isEditable = false
            textView.sizeToFit()
            textView.isScrollEnabled = false
            textView.textAlignment = text.language.textAlignment
            textView.semanticContentAttribute = text.language.semanticContentAttribute
            textView.delegate = self
            svRootDescriptions.addArrangedSubview(textView)
        }
    }
    
    @objc func onCustomButtonClicked(_ sender: CustomButton) {
        delegate?.onButtonClicked(value: sender.value ?? "")
    }
    
    private func configureImageCollectionView() {
        collectionViewImage.dataSource = self
        collectionViewImage.delegate = self
        collectionViewImage.reloadData()
        pageControlImages.numberOfPages = chat?.attachment?.content?.images?.count ?? 0
    }
}

extension ChatLeftTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chat?.attachment?.content?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.updateCell(imageUrl: chat?.attachment?.content?.images?[indexPath.row]?.url ?? "")
        return cell
    }
}

extension ChatLeftTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        pageControlImages.currentPage = currentPage
    }
}

extension ChatLeftTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        delegate?.onLinkClicked(with: URL)
        return false
    }
}
