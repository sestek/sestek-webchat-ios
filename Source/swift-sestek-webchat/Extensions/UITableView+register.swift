//
//  UITableView+register.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 21.07.2022.
//

import UIKit

extension UITableView {
    func register(cell: UITableViewCell.Type) {
        let bundle = Bundle(for: cell.self)
        let nib = UINib(nibName: cell.identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: cell.identifier)
    }
}
