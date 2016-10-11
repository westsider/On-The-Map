//
//  Alerts.swift
//  On The Map
//
//  Created by Warren Hansen on 10/8/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//  Creates an Alert View Controller error message
//

import Foundation
import UIKit

// help with abstraction from http://stackoverflow.com/questions/36915725/attempt-to-present-whose-view-is-not-in-the-window-hierarchy

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
