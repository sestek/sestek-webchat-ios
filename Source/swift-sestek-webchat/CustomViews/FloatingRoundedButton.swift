//
//  FloatingRoundedButton.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 22.08.2022.
//

import UIKit

class FloatingRoundedButtonController: UIViewController {
    
    static let sharedInstance = FloatingRoundedButtonController()

    private(set) var button: UIButton!
    
    private lazy var popoverWindow: UIWindow = {
        var frame: CGRect = UIScreen.main.bounds
        let popoverWindow = UIWindow(frame: .zero)

        if #available(iOS 13.0, *), let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            frame = windowScene.coordinateSpace.bounds
            popoverWindow.windowScene = windowScene
        }
        popoverWindow.windowLevel = UIWindow.Level.normal
        popoverWindow.frame =  frame
        
        let navigationController = UINavigationController()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = CustomConfiguration.config.headerColor
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.compactAppearance = appearance
        } else {
            navigationController.navigationBar.barTintColor = .barBackgroundColor
        }
        
        navigationController.navigationBar.tintColor = .tintColor
        let vc = ChatViewController.loadFromNib()
        navigationController.viewControllers = [vc]
        navigationController.modalPresentationStyle = .fullScreen
        popoverWindow.rootViewController = navigationController

        return popoverWindow
    }()

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
        button.setImage(.ic_button_knovvu_logo, for: .normal)
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
        SestekWebChat.shared.startConversation()
    }
    
    func updatePopoverVisibility(to state: PopoverVisibility) {
        let openedFrame = UIScreen.main.bounds
        var closedFrame = openedFrame
        closedFrame.origin.y = closedFrame.size.height

        popoverWindow.frame = state == .open ? closedFrame : openedFrame

        popoverWindow.isHidden = false
        window.isHidden = state == .open
        view.window?.alpha = state == .closed ? 0 : 1

        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .calculationModeCubicPaced] , animations: {
            self.popoverWindow.frame = state == .open ? openedFrame : closedFrame
            self.view.window?.alpha = state == .open ? 0 : 1
        }, completion: { (finished: Bool) in
            self.popoverWindow.isHidden = state == .closed
        })
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
