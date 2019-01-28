//
//  UIViewController + Additions.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController{
    
    func showAlert(_ title: String?,
                   message: String?,
                   buttonsDictionary buttons: Dictionary<String, (UIAlertAction?) -> Void>!,
                   baseController parentVC: UIViewController!, preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
        
        let alertController: UIAlertController = UIAlertController(title: title,
                                                                   message: message,
                                                                   preferredStyle: preferredStyle)
        
        var count: Int = 0
        for (bTitle, bAction) in buttons {
            if bTitle != "" {
                var style: UIAlertAction.Style = UIAlertAction.Style.destructive
                if count > 1 {
                    style = UIAlertAction.Style.destructive
                } else if count == 1 {
                    style = UIAlertAction.Style.default
                } else {
                    style = UIAlertAction.Style.cancel
                }
                
                let alertAction: UIAlertAction = UIAlertAction(title: bTitle, style: style, handler: bAction)
                alertController.addAction(alertAction)
            }
            count += 1
        }
        parentVC.presentViewController(alertController, animated: true)
        
        return alertController
    }
    
    func presentViewController(_ viewControllerToPresent: UIViewController) {
        self.presentViewController(viewControllerToPresent, animated: true)
    }
    
    func presentViewController(_ viewControllerToPresent: UIViewController, animated flag: Bool) {
        self.present(viewControllerToPresent, animated: flag) { () -> Void in
        }
    }
}
