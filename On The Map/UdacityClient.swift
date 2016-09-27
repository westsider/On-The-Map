//
//  UdacityClient.swift
//  On The Map
//
//  Created by Warren Hansen on 9/26/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.

//  im sure im not calling my login correctly, 
//  how return any errors or login
//  how save account key and session id

import Foundation

class UdacityClient {
    
    //var appDelagate: AppDelegate!
    // Class Vars
    
    //var account: String? = nil
    var registered: Bool? = nil
    var accountKey: String? = nil  // Account-Key
    var sessionID: String? = nil //Session-ID
    var expiration: String? = nil
    
    // MARK: Make Network Request on Udacity
    func logInToUdacity (user: String, password: String) -> String {

         /* 1. Set the parameters
         let methodParameters = [
         Constants.TMDBParameterKeys.ApiKey: Constants.TMDBParameterValues.ApiKey
         ]
         // 2/3. Build the URL, Configure the request
         let request = NSURLRequest(URL: appDelegate.tmdbURLFromParameters(methodParameters, withPathExtension: "/authentication/token/new"))
         */
        
        let request = Constants.Udacity.APIBaseURL
        request.httpMethod = Constants.UdacityParameterValues.Method
        request.addValue(Constants.UdacityParameterKeys.AppJson, forHTTPHeaderField: Constants.UdacityParameterKeys.Accept)
        request.addValue(Constants.UdacityParameterKeys.AppJson, forHTTPHeaderField: Constants.UdacityParameterKeys.Content)
        //request.httpBody = Constants.UdacityParameterValues.JsonBody.data(using: String.Encoding.utf8)
        request.httpBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        print("THIS IS THE REQUEST: \(request)")
        // aka task 3 types data, download, upload
        let session = URLSession.shared
        
        // 4 create network request
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String) {
                print(error)
                print("URL at time of error: \(request)")
                performUIUpdatesOnMain {
                    //self.setUIEnabled(enabled: true)
                    //self.debugWindow.text = "API Error: " + error
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
                self.accountKey = jsonResult["key"] as? String
                print("Account-Key: \(self.accountKey)")
                print(" ")
                
            }
            if let jsonResult = parsedResult["session"] as? [String: AnyObject] {
                self.sessionID = jsonResult["id"] as? String
                print("Session-ID: \(self.sessionID)")
                print(" ")
                
            }
            
            // getting somewhere - not sure how to update main or return error
            performUIUpdatesOnMain {
//                if self.accountKey != nil {
//                    return "Account-Key: \(self.accountKey) Session-ID: \(self.sessionID)"
//                } else {
//                    return "Error Logging In"
//                }
            }
        }
        task.resume()

        return "Output string test" // need to return any errors
    }
    
}




