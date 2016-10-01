//
//  LogOnViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 9/23/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.


import UIKit
import Foundation

class LogOnViewController: UIViewController  {
    
    
   // var abc = UdacityClient.foobar(a:10)
    
    
    var appDelagate: AppDelegate!
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var debugWindow: UITextView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginFbButtob: UIButton!
    
    var accountKey = ""
    
    var sessionID = ""
    
    // log in button + log in function call to my custom API
    @IBAction func logInAction(_ sender: AnyObject) {
        
        let userName = self.userEmail.text!
        let password = self.userPassword.text!
        
        UdacityClient().logInToUdacity(user: userName, password: password, completionHandler: { (success, error) -> Void in
            if error != nil {
                self.debugWindow.text = error
            } else {
                self.debugWindow.text = success as! String!
            }
        })
        
    }
    
    @IBAction func loginFacebookAction(_ sender: AnyObject) {
         debugWindow.text = "FaceBook API Not Available Yet"
    }
    
    // MARK: Configure UI
    private func setUIEnabled(enabled: Bool) {
        loginButton.isEnabled = true
        loginFbButtob.isEnabled = true
        //grabImageButton.enabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
            loginFbButtob.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
            loginFbButtob.alpha = 0.3
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get the app delgate
        appDelagate = UIApplication.shared.delegate as! AppDelegate!
    }
    

    
}


