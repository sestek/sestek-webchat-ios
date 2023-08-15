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
    
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imagesTableView: UITableView!
    @IBOutlet private weak var buttonsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var buttonsCollectionView: UICollectionView!
    @IBOutlet private weak var globalView: UIView!
    
    var buttonResponse: [ButtonResponseModel]? = nil
    var imageUrlList: [String]? = []
    var maxHeight: CGFloat = .zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonsCollectionView.register(cell: ButtonCollectionViewCell.self)
        buttonsCollectionView.delegate = self
        buttonsCollectionView.dataSource = self
        imagesTableView.delegate = self
        imagesTableView.dataSource = self
        imagesTableView.isScrollEnabled = false
        imagesTableView.register(cell: AttachmentImageTableViewCell.self)
        imagesTableView.separatorStyle = .none
    }
    
    private struct Constant {
        static let buttonHeight: CGFloat = 40
        static let eachButtonSpacing: CGFloat = 10
        static let buttonsToBottomHeight: CGFloat = 10
        static let buttonsToTopHeight: CGFloat = 10
        static var imageHeight: Int = 100
    }
    
    func updateCell(_ imageUrlList: [String]?,
                    buttonResponse: [ButtonResponseModel]?,
                    maxHeight: CGFloat,
                    delegate: ImageCollectionViewCellDelegate) {
        self.imageUrlList = imageUrlList
        self.delegate = delegate
        self.maxHeight = maxHeight
        self.buttonResponse = buttonResponse
        if let imageUrlList = imageUrlList {
            // image containts bottom buttona göre
            //imagesTableView.bottomAnchor.constraint(equalTo: buttonsCollectionView.bottomAnchor, constant: 100)
            tableViewHeightConstraint.constant = CGFloat(Constant.imageHeight * imageUrlList.count)
        } else {
            tableViewHeightConstraint.constant = 0
        }
        imagesTableView.reloadData()
        if let _ = buttonResponse {
            buttonsCollectionViewHeight.constant = maxHeight + Constant.buttonsToBottomHeight + Constant.buttonsToTopHeight + 10
        } else {
            buttonsCollectionViewHeight.constant = Constant.buttonsToBottomHeight + Constant.buttonsToTopHeight + 10
        }        
        buttonsCollectionView.reloadData()
    }
}
extension ImageCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.identifier, for: indexPath) as? ButtonCollectionViewCell {
            if let response = buttonResponse?[safe: indexPath.row] {
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
extension ImageCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageUrlList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentImageTableViewCell.identifier, for: indexPath) as? AttachmentImageTableViewCell {
            if let url = imageUrlList?[indexPath.row] {
                cell.updateCell(url)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(Constant.imageHeight)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView(frame: .zero)
    }
}
