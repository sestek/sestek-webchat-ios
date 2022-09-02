//
//  AlertUtil.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 1.09.2022.
//

import UIKit

class AlertUtil {
    func showStandardAlert(parentController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            switch action.style{
                case .default:
                    alertController.dismiss(animated: true, completion: nil)
                    break
                case .cancel:
                    break
                case .destructive:
                    break
            @unknown default:
                break
            }
        }))
        parentController.present(alertController, animated: true, completion: nil)
    }
    
    func showStandardAlert(parentController: UIViewController, message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            switch action.style{
                case .default:
                    alertController.dismiss(animated: true, completion: nil)
                    break
                case .cancel:
                    break
                case .destructive:
                    break
            @unknown default:
                break
            }
        }))
        parentController.present(alertController, animated: true, completion: nil)
    }
    
    func showStandardAlertWithCompletion(parentController: UIViewController, title: String, message: String, completion: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            switch action.style{
                case .default:
                    completion()
                    alertController.dismiss(animated: true, completion: nil)
                    break
                case .cancel:
                    break
                case .destructive:
                    break
            @unknown default:
                break
            }
        }))
        parentController.present(alertController, animated: true, completion: nil)
    }
    
    func showStandardAlertWithOptions(parentController: UIViewController, title: String, message: String, firstOptionTitle: String, secondOptionTitle: String, firstOptionAction: @escaping (() -> Void), secondOptionAction: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: firstOptionTitle, style: .default, handler: { (action) in
            switch action.style{
                case .default:
                    firstOptionAction()
                    break
                case .cancel:
                    break
                case .destructive:
                    break
            @unknown default:
                break
            }
        }))
        alertController.addAction(UIAlertAction(title: secondOptionTitle, style: .default, handler: { (action) in
            switch action.style{
                case .default:
                    secondOptionAction()
                    break
                case .cancel:
                    break
                case .destructive:
                    break
            @unknown default:
                break
            }
        }))
        parentController.present(alertController, animated: true, completion: nil)
    }
    
    func showStandardAlertAndGoBack(parentController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            switch action.style{
            case .default:
                alertController.dismiss(animated: true, completion: nil)
                parentController.navigationController?.popViewController(animated: true)
                break
            case .cancel:
                break
            case .destructive:
                break
            @unknown default:
                break
            }
        }))
        parentController.present(alertController, animated: true, completion: nil)
    }
    
    func showStandardAlertWithAction(parentController: UIViewController, title: String, message: String, optionAction: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            switch action.style{
                case .default:
                    optionAction()
                    alertController.dismiss(animated: true, completion: nil)
                    break
                case .cancel:
                    break
                case .destructive:
                    break
            @unknown default:
                break
            }
        }))
        parentController.present(alertController, animated: true, completion: nil)
    }
}
