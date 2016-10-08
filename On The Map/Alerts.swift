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
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true,completion: nil)
    }
}

//
//class AlertView: UIViewController {
//    
//    var title:String
//    var error:String
//    
//    init(title:String, error:String){
//        self.title = title
//        self.error = error
//    }
//    
////    func errorAlert(_ title: String, error: String) {
////        let controller: UIAlertController = UIAlertController(title: title, message: error, preferredStyle: .alert)
////        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////        present(controller, animated: true, completion: nil)
////    }
//}

//class AlertView: UIViewController {
//    var alertTitle:String
//    var error:String
//    init(title: String, error:String) {
//        self.alertTitle = title
//        self.error = error
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func myErrorAlert(alertTitle: String, error: String)-> Void {
//        
//    }
//}

//class Starship{
//    var prefix: String?
//    var name: String
//    init(name: String, prefix: String? = nil) {
//        self.name = name
//        self.prefix = prefix
//    }
//    var fullName: String {
//        return (prefix != nil ? prefix! + " " : "") + name
//    }
//}
