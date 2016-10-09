//
//  LogOnViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 9/23/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.

//  add facebook login
//  location search fail return text in text box - so its visible?

import UIKit
import Foundation

class LogOnViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate  {
    
    // MARK: Variables + Outlets
    let loginViewToTabViewSegue = "loginViewToTabViewSegue"
    
    var accountKey = ""
    
    var sessionID = ""
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var debugWindow: UITextView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityCircle: UIActivityIndicatorView!
    
    @IBOutlet weak var loginFbButtob: UIButton!

    @IBOutlet weak var mailIcon: UIImageView!
    
    @IBOutlet weak var lockIcon: UIImageView!
    
    // MARK: Login With Facebook Function
    @IBAction func loginFacebookAction(_ sender: AnyObject) {
        debugWindow.text = "FaceBook API Not Available Yet"
    }
    
    // MARK: Login with Email Function
    @IBAction func logInAction(_ sender: AnyObject) {

        // reduce the alpha and disable text entry
        setUIEnabled(enabled: false)
        
        // MARK: Check User and Password Fields
        if (userEmail.text == "" || userEmail.text == "user" || userPassword.text == "" || userPassword.text == "password") {
            textDisplay("Please enter a username and password.")
            SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Need some input...", message: "Please enter a username and password.")
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
                                    // MARK: Error Getting User ID
                                    DispatchQueue.main.async(execute: {
                                        SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Fetch Info", message: errorString!)
                                        self.setUIEnabled(enabled: true)
                                    })
                                }
                            }
                        } else {
                            // MARK: JSON Error
                            DispatchQueue.main.async(execute: {
                                SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Json Error", message: errorString!)
                                self.setUIEnabled(enabled: true)
                            })
                        }
                    }
                } else {
                    // MARK: Login Error
                    DispatchQueue.main.async(execute: {
                        SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Login Failed", message: errorString!)
                        self.setUIEnabled(enabled: true)
                    })
                }
            }
        }
    }
    
    // MARK: Complete Login
    func completeLogin() {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: self.loginViewToTabViewSegue, sender: self)
        })
    }
    
    // MARK: Account Sign Up
    @IBAction func accountSignUp(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    // MARK: Configure UI
    private func setUIEnabled(enabled: Bool) {
        loginButton.isEnabled = true
        loginFbButtob.isEnabled = true
        userEmail.isEnabled = true
        userPassword.isEnabled = true
        mailIcon.isHidden = false
        lockIcon.isHidden = false
        
        if enabled {
            loginButton.alpha = 1.0
            loginFbButtob.alpha = 1.0
            userEmail.alpha = 1.0
            userPassword.alpha = 1.0
            mailIcon.alpha = 1.0
            lockIcon.alpha = 1.0
            activityCircle.stopAnimating()
            textDisplay(" ")
        } else {
            loginButton.alpha = 0.3
            loginFbButtob.alpha = 0.3
            userEmail.alpha = 0.3
            userPassword.alpha = 0.3
            mailIcon.alpha = 0.3
            lockIcon.alpha = 0.3
        }
    }
    
    // MARK: Display Text to UI.
    func textDisplay(_ errorString: String?) {
        DispatchQueue.main.async(execute: {
            if let errorString = errorString {
                self.debugWindow.text = errorString
                //The login button in re-enabled so that the user can try again.
                self.loginButton.isEnabled = true
            }
        })
    }
}
