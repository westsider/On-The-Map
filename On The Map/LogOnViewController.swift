//
//  LogOnViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 9/23/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//  Getting the request token V2 beinning is app delegate

import UIKit

class LogOnViewController: UIViewController {
    
    var appDelagate: AppDelegate!
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var debugWindow: UITextView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginFbButtob: UIButton!
    
    var accountKey = ""
    
    var sessionID = ""
    
    @IBAction func logInAction(_ sender: AnyObject) {
        
        logInToUdacity()
    }
    
    @IBAction func loginFacebookAction(_ sender: AnyObject) {
         debugWindow.text = "FaceBook Login Not Available"
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
    
    // MARK: Make Network Request on Udacity
    private func logInToUdacity () {
        // let methodParameters = {   var pass = self.userPassword.text; var email = self.userEmail }
        
        let email = self.userEmail.text!
        let password = self.userPassword.text!
        
        if self.userEmail.text!.isEmpty || userPassword.text!.isEmpty {
            debugWindow.text = "Username or Password Empty."
        } else {
            setUIEnabled(enabled: false)
            
            // create url and request
            let request = Constants.Udacity.APIBaseURL
            request.httpMethod = Constants.UdacityParameterValues.Method
            request.addValue(Constants.UdacityParameterKeys.AppJson, forHTTPHeaderField: Constants.UdacityParameterKeys.Accept)
            request.addValue(Constants.UdacityParameterKeys.AppJson, forHTTPHeaderField: Constants.UdacityParameterKeys.Content)
            //request.httpBody = Constants.UdacityParameterValues.JsonBody.data(using: String.Encoding.utf8)
            request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
            print("THIS IS THE REQUEST: \(request)")
            let session = URLSession.shared
            
            // create network request
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                
                // if an error occurs, print it and re-enable the UI
                func displayError(error: String) {
                    print(error)
                    print("URL at time of error: \(request)")
                    performUIUpdatesOnMain {
                        self.setUIEnabled(enabled: true)
                        self.debugWindow.text = "API Error: " + error
                    }
                }
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    displayError(error: "There was an error with your request: \(error)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                    displayError(error: "Your request returned a status code other than 2xx!")
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    displayError(error: "No data was returned by the request!")
                    return
                }
                
                let dataLength = data.count
                let r = 5...Int(dataLength)
                let newData = data.subdata(in: Range(r)) /* subset response data! */
                print(" ")
                print("HERE IS MY KEY + SESSION ID:----------------------------------------------------------------------")
                print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
                print(" ")
                
                // parse the data
                let parsedResult: [String:AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
                } catch {
                    displayError(error: "Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                if let jsonResult = parsedResult["account"] as? [String: AnyObject] {
                    self.accountKey = jsonResult["key"] as! String
                    print("Account-Key: \(self.accountKey)")
                    print(" ")
                    
                }
                if let jsonResult = parsedResult["session"] as? [String: AnyObject] {
                    self.sessionID = jsonResult["id"] as! String
                    print("Session-ID: \(self.sessionID)")
                    print(" ")
                    
                }
                performUIUpdatesOnMain {
                    self.debugWindow.text = "Login Successful! \r\n Account-Key: \(self.accountKey) \r\n Session-ID: \(self.sessionID)"
                    self.setUIEnabled(enabled: true)
                }
               
                
            }
            task.resume()
           
        }
         //self.debugWindow.text = "Account-Key: \(self.accountKey) Session-ID: \(self.sessionID)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delgate
        appDelagate = UIApplication.shared.delegate as! AppDelegate!
    }
    
    // MARK: Helper for Escaping Parameters in URL
    
    private func escapedParameters(_ parameters: [String:Any]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
}


