//
//  LogOnViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 9/23/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.


import UIKit
import Foundation

class LogOnViewController: UIViewController  {

    var appDelagate: AppDelegate!
    
    let loginViewToTabViewSegue = "loginViewToTabViewSegue"
    
    //var loginSuccessful = false
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var debugWindow: UITextView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginFbButtob: UIButton!
    
    var accountKey = ""
    
    var sessionID = ""
    
    // log in button + log in function call to my custom API
    @IBAction func logInAction(_ sender: AnyObject) {
        
        //  let userName = self.userEmail.text!
        //  let password = self.userPassword.text!
        let userName = "whansen1@mac.com"
        let password = "wh2403wh"
        
        setUIEnabled(enabled: false)
        
        UdacityClient().logInToUdacity(user: userName, password: password, completionHandler: { (success, error) -> Void in
            if error != nil {
                self.debugWindow.text = error
                self.setUIEnabled(enabled: true)
                // MARK: TODO Pust this to alert VC
            }
            if success != nil {
                print(success!)
                performUIUpdatesOnMain{
                self.debugWindow.text = success!
                self.setUIEnabled(enabled: true)
                self.loginSuccessful()
                }
            }
            
        })
        
    }

    func loginSuccessful() {
        Parse().retrieveMapData()
        // segue to tableview
        //tabBarController.userModel = userModel
        performSegue(withIdentifier: loginViewToTabViewSegue, sender: self)
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


