//
//  ChatLeftTableViewCell.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 19.08.2022.
//

import UIKit
import MapKit

protocol ChatTableViewCellDelegate: AnyObject {
    func onButtonClicked(value: String)
    func onLinkClicked(with url: URL)
    func onMapCliked(latitude: Double, longitude: Double)
}

class ChatLeftTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var viewRoot: UIView! {
        didSet {
            viewRoot.clipsToBounds = true
            viewRoot.layer.cornerRadius = 10
            viewRoot.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            viewRoot.makeShadow()
            viewRoot.backgroundColor = CustomConfiguration.config.messageBoxColor
        }
    }
    @IBOutlet weak var attachmentCollectionViewHeightConstraint: NSLayoutConstraint!
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
    @IBOutlet private weak var attachmentCollectionView: SelfSizingCollectionView! {
        didSet {
            attachmentCollectionView.register(cell: AttachmentCollectionViewCell.self)
        }
    }
    @IBOutlet weak var pageControlImages: UIPageControl!
    @IBOutlet private weak var svRootLocations: UIStackView!
    
    private weak var delegate: ChatTableViewCellDelegate?
    private var chat: ChatModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(chat: ChatModel?, delegate: ChatTableViewCellDelegate?, content: ChatbotView) {
        self.delegate = delegate
        self.chat = chat
        setDefaultUI()
        setLabels(texts: TextHelper().getTextsWithAttributes(chat?.text), content: content)
        labelTime.text = (chat?.date ?? "").getDate(formatter: .yyyyMMddTHHmmssSSSSSSSZ)?.getAsString(.yyyyMMddHHmm)
        svRootLocations.isHidden = true
        if let buttons = (chat?.attachment?.first?.content?.buttons), buttons.count > 0 {
            svRootButtons.isHidden = false
            setButtons(buttons: chat?.attachment?.first?.content?.buttons)
        }
        if !(chat?.attachment?.isEmpty ?? false) {
            svImages.isHidden = false
        }
        if let location = chat?.location {
            svRootLocations.isHidden = false
            setLocation(location: location)
        }
        configureImageCollectionView()
    }
    
    private func setDefaultUI() {
        svRootButtons.isHidden = true
        svImages.isHidden = true
        attachmentCollectionView.delegate = nil
        attachmentCollectionView.dataSource = nil
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
    
    private func setLabels(texts: [CustomText], content: ChatbotView) {
        svRootDescriptions.subviews.forEach { $0.removeFromSuperview() }
       contentHeightConstraint.constant = content.height
       content.webView.textColor = CustomConfiguration.config.messageColor
       svRootDescriptions.addArrangedSubview(content)
    }
    
    private func setLocation(location: GeoResponseModel) {
        svRootLocations.subviews.forEach { $0.removeFromSuperview() }
        let viewRoot = UIView()
        viewRoot.translatesAutoresizingMaskIntoConstraints = false
        
        let mapView = MKMapView()
        mapView.isPitchEnabled = false
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewRoot.heightAnchor.constraint(equalToConstant: 200),
            viewRoot.widthAnchor.constraint(equalToConstant: svRootLocations.frame.width),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            mapView.widthAnchor.constraint(equalToConstant: svRootLocations.frame.width)
        ])
        
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude ?? 0.0, longitude: location.longitude ?? 0.0)
        annotation.coordinate = coordinate
        annotation.title = location.name ?? ""
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMapClicked(_:))))
        viewRoot.addSubview(mapView)
        svRootLocations.addArrangedSubview(viewRoot)
    }
    
    @objc func onCustomButtonClicked(_ sender: CustomButton) {
        delegate?.onButtonClicked(value: sender.value ?? "")
    }
    
    @objc private func onMapClicked(_ sender: UITapGestureRecognizer) {
        guard let latitude = chat?.location?.latitude,
              let longitude = chat?.location?.longitude else { return }
        delegate?.onMapCliked(latitude: latitude, longitude: longitude)
    }
    
    private func configureImageCollectionView() {
        if chat?.layout == .carousel {
            attachmentCollectionViewHeightConstraint.constant = getCalculatedHeightOfAttachment(forCollectionView: attachmentCollectionView)
            attachmentCollectionView.dataSource = self
            attachmentCollectionView.delegate = self
            attachmentCollectionView.isPagingEnabled = true
            attachmentCollectionView.reloadData()
            pageControlImages.numberOfPages = chat?.attachment?.count ?? 0
        } else {
            attachmentCollectionViewHeightConstraint.constant = 0
        }
    }
    
    private func getMaxHeightOfImage() -> CGFloat {
        var maxHeight: CGFloat = 0
        chat?.attachment?.enumerated().forEach { index, element in
            maxHeight = max(maxHeight,(chat?.attachment?[index].content?.images?.isEmpty ?? true ? 0 : 160))
        }
        return maxHeight
    }
    
    private func getMaxHeightOfButtons() -> CGFloat {
        var maxHeight: Int = 0
        chat?.attachment?.enumerated().forEach { index, element in
            let buttonsCount = chat?.attachment?[index].content?.buttons?.count ?? 1
            let totalButtonsHeight = (buttonsCount * 40)
            let eachSpacingBetweenButtons = buttonsCount * 10
            let totalHeight = totalButtonsHeight + eachSpacingBetweenButtons
            maxHeight = max(totalHeight, maxHeight)
        }
        return CGFloat(maxHeight)
    }
    
    private func getTitlesHeight(forCollectionView collectionView: UICollectionView) -> CGFloat {
        
        var maxHeight: Int = 0
        chat?.attachment?.enumerated().forEach { index, element in
            let titleHeight = chat?.attachment?[index].content?.title?.height(constraintedWidth: collectionView.bounds.width - 20, font: .systemFont(ofSize: 13, weight: .regular)) ?? 0
            let subTitle = chat?.attachment?[index].content?.title ?? chat?.attachment?[index].content?.subtitle
            let subTitleHeight = subTitle?.height(constraintedWidth: collectionView.bounds.width - 20, font: .systemFont(ofSize: 13, weight: .regular)) ?? 0
            let totalHeight = titleHeight + subTitleHeight
            maxHeight = max(Int(totalHeight), maxHeight)
        }
        let spacingBetweenLabels: Int = 40
        return CGFloat(spacingBetweenLabels + 40)
    }
    
    func getCalculatedHeightOfAttachment(forCollectionView collectionView: UICollectionView) -> CGFloat {
        getMaxHeightOfImage() + getMaxHeightOfButtons() + getTitlesHeight(forCollectionView: collectionView)
    }
}

extension ChatLeftTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chat?.attachment?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachmentCollectionViewCell", for: indexPath) as! AttachmentCollectionViewCell
        if let attachment = chat?.attachment {
            let item = attachment[indexPath.row]
            cell.updateCell(item, height: getMaxHeightOfImage() + getMaxHeightOfButtons(), maxButtonHeight: getMaxHeightOfButtons(), delegate: self)
        }
        return cell
    }
}

extension ChatLeftTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: getCalculatedHeightOfAttachment(forCollectionView: attachmentCollectionView))
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
extension ChatLeftTableViewCell: AttachmentCollectionViewCellDelegate {
    func onButtonClicked(value: String) {
        delegate?.onButtonClicked(value: value)
    }
}
