//
//  UIImageView+Extensions.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 19.08.2022.
//

import UIKit

extension UIImageView {
    func setImage(with urlString: String?) {
        guard let url = URL(string: urlString ?? "") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
    
    static func imageWithBundle(_ name: String) -> UIImage? {
        if let image = UIImage(named: name, in: Bundle.sestekBundle(), compatibleWith: nil) {
            return image
        }
        return UIImage()
    }
}
