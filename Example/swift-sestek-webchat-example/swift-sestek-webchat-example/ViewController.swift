//
//  ViewController.swift
//  swift-sestek-webchat-example
//
//  Created by Ömer Sezer on 6.08.2022.
//

import UIKit
import sestek_webchat_ios

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapBtnStartConversation(_ sender: Any) {
        SestekWebChat.shared.startConversation()
    }
    
    @IBAction func didTapBtnEndConversation(_ sender: Any) {
        SestekWebChat.shared.endConversation()
    }
    
    @IBAction func didTapBtnTriggerVisible(_ sender: Any) {
        SestekWebChat.shared.triggerVisible(self)
    }
}
