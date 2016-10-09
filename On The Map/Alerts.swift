//
//  Alerts.swift
//  On The Map
//
//  Created by Warren Hansen on 10/8/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//  Creates an Alert View Controller error message

import Foundation
import UIKit


// found a way to abstract my alert controller here
// http://stackoverflow.com/questions/36915725/attempt-to-present-whose-view-is-not-in-the-window-hierarchy

class SPSwiftAlert: UIViewController {
    
    internal var defaultTextForNormalAlertButton = "OK"
    static let sharedObject = SPSwiftAlert()
    
    func showNormalAlert(controller: UIViewController, title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: defaultTextForNormalAlertButton, style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        controller.present(alert, animated: true, completion: nil)
    }
}

// cant get this function to call a segue
//class SwiftyAlert: UIViewController {
//    
//    static let sharedObject = SwiftyAlert()
//    
//    func showDoubleAlert(controller: UIViewController, title: String, message: String)-> Bool {
//        var thisResult = false
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
//            thisResult =  false
//        }
//        let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
//            thisResult = true
//        }
//        alertController.addAction(cancelAction)
//        alertController.addAction(overwriteAction)
//        controller.present(alertController, animated: true, completion: nil)
//        return thisResult
//    }
//    
//}

