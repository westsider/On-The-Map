//
//  Alerts.swift
//  On The Map
//
//  Created by Warren Hansen on 10/8/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//  Creates an Alert View Controller error message

import Foundation
import UIKit

class alertManager: NSObject {
    func notifyUser(title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // background color
        let myLtBlueColor = UIColor(red: 1.0/255.0, green: 1.0/255.0, blue: 255.0/255.0, alpha: 0.5)
        let backView = alert.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = myLtBlueColor
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true,completion: nil)
    }
}

// found a way to abstract my alert controller here
// http://stackoverflow.com/questions/36915725/attempt-to-present-whose-view-is-not-in-the-window-hierarchy
class SPSwiftAlert: UIViewController {
    
    //#MARK: - Members
    
    internal var defaultTextForNormalAlertButton = "OK"
    
    static let sharedObject = SPSwiftAlert()
    
    //#MARK: Functions
    
    func showNormalAlert(controller: UIViewController, title: String, message: String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: defaultTextForNormalAlertButton, style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        controller.present(alert, animated: true, completion: nil)
        
    }    
}
