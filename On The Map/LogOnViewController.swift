//
//  LogOnViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 9/23/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//  add facebook login

//  move button to right place with auto layout
//  when connected, segue to map
//  figure out if I need username to find if I have posted on map

//  clean up location search storyboard

import UIKit
import Foundation
import FBSDKLoginKit

class LogOnViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, FBSDKLoginButtonDelegate  {
    
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
        
        userEmail.text = "whansen1@mac.com"
        userPassword.text = "wh2403wh"
        
        if textInputIncomplete() {
            return
            
        } else {
            //get userID
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
    
    //MARK: Check Text Input
    func textInputIncomplete()-> Bool {
        // reduce the alpha and disable text entry
        setUIEnabled(enabled: false)
        if (userEmail.text == "" || userEmail.text == "user" || userPassword.text == "" || userPassword.text == "password") {
            textDisplay("Please enter a username and password.")
            SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Need some input...", message: "Please enter a username and password.")
            setUIEnabled(enabled: true)
            return true
        } else {
            return false
        }
    }
    
    // MARK: Configure UI
    func setUIEnabled(enabled: Bool) {
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
    
    //# MARK: Lifecycle Functions for Facebook Login
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Facebook code
        if (FBSDKAccessToken.current() != nil ) {
            
            print("User Logged In")
            
        } else {
            
            let loginButton = FBSDKLoginButton()
            
            loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile", "email"]
            loginButton.delegate = self
            self.view.addSubview(loginButton)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
        } else if result.isCancelled {
            print("User Cancelled login")
        } else {
            if result.grantedPermissions.contains("email")
            {
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) {
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        
                        if error != nil {
                            print(error)
                        } else {
                            if let userDetails = result as? [String:String] {
                                print("Email: \(userDetails["email"])")
                                print("ID: \(userDetails["id"])")
                                print("Name: \(userDetails["name"])")
                            }
                        }
                    })
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Logged Out")
        
    }
}
