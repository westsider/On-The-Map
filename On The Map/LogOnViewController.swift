//
//  LogOnViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 9/23/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.


import UIKit
import Foundation

class LogOnViewController: UIViewController  {
    
    let loginViewToTabViewSegue = "loginViewToTabViewSegue"
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var debugWindow: UITextView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityCircle: UIActivityIndicatorView!
    
    @IBOutlet weak var loginFbButtob: UIButton!
    
    @IBAction func accountSignUp(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    var accountKey = ""
    
    var sessionID = ""
    
    // MARK: log in button pressed
    @IBAction func logInAction(_ sender: AnyObject) {
        
        // reduce the alpha and disable text entry
        setUIEnabled(enabled: false)
        
        //Check for empty or default user and password
        if (userEmail.text == "" || userEmail.text == "user" || userPassword.text == "" || userPassword.text == "password") {
            textDisplay("Please enter a username and password.")
            setUIEnabled(enabled: true)
            return
        //get userID
        } else {
            textDisplay("Contacting Udacity...")
            activityCircle.startAnimating();
            UdacityLogin.sharedInstance().loginToUdacity(username: self.userEmail.text!, password: self.userPassword.text!) { (success, errorString) in
                if success {
                    
                    //Fetching first and last name from Udacity.
                    UdacityLogin.sharedInstance().setFirstNameLastName() { (success, errorString) in
                        if success {
                            
                            //Fetching student information from Parse.
                            MapPoints.sharedInstance().fetchData() { (success, errorString) in
                                if success {
                                    self.textDisplay("Login Complete")
                                    self.completeLogin()
                                } else {
                                    self.textDisplay(errorString)
                                }
                            }
                        } else {
                            self.textDisplay(errorString)
                        }
                    }
                } else {
                    self.textDisplay(errorString)
                }
            }
        }
    }
    
    @IBAction func loginFacebookAction(_ sender: AnyObject) {
         debugWindow.text = "FaceBook API Not Available Yet"
    }
    
    // MARK: Configure UI
    private func setUIEnabled(enabled: Bool) {
        loginButton.isEnabled = true
        loginFbButtob.isEnabled = true
        userEmail.isEnabled = true
        userPassword.isEnabled = true
        
        if enabled {
            loginButton.alpha = 1.0
            loginFbButtob.alpha = 1.0
            userEmail.alpha = 1.0
            userPassword.alpha = 1.0
        } else {
            loginButton.alpha = 0.3
            loginFbButtob.alpha = 0.3
            userEmail.alpha = 0.3
            userPassword.alpha = 0.3
        }
    }
    
    // MARK: Display text to UI.
    func textDisplay(_ errorString: String?) {
        DispatchQueue.main.async(execute: {
            if let errorString = errorString {
                self.debugWindow.text = errorString
                //The login button in re-enabled so that the user can try again.
                self.loginButton.isEnabled = true
            }
        })
    }
    
    func completeLogin() {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: self.loginViewToTabViewSegue, sender: self)
        })
    }
}


