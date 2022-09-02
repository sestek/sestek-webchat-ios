//
//  FloatingRoundedButton.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 22.08.2022.
//

import UIKit

protocol FloatingRoundedButtonDelegate: AnyObject {
    func onButtonClicked()
}

class FloatingRoundedButtonController: UIViewController {
    
    static let sharedInstance = FloatingRoundedButtonController()
    weak var delegate: FloatingRoundedButtonDelegate?

    private(set) var button: UIButton!

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        window.rootViewController = self
    }

    private let window = FloatingRoundedButtonWindow()

    override func loadView() {
        let view = UIView()
        let button = UIButton(type: .custom)
        button.setImage(UIImageView.imageWithBundle("knovvu_logo"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = UIColor.white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize.zero
        button.layer.cornerRadius = 30
        button.sizeToFit()
        button.addTarget(self, action: #selector(onButtonClicked(_:)), for: .touchUpInside)
        let x = window.bounds.width - 76
        let y = window.bounds.height - 76
        button.frame = CGRect(x: x, y: y, width: 60, height: 60)
        button.autoresizingMask = []
        view.addSubview(button)
        self.view = view
        self.button = button
        window.button = button
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func hideButton() {
        window.isHidden = true
    }
    
    func showButton() {
        window.isHidden = false
    }
    
    @objc func onButtonClicked(_ sender: UIButton) {
        delegate?.onButtonClicked()
    }

}

private class FloatingRoundedButtonWindow: UIWindow {

    var button: UIButton?

    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let button = button else { return false }
        let buttonPoint = convert(point, to: button)
        return button.point(inside: buttonPoint, with: event)
    }
}
