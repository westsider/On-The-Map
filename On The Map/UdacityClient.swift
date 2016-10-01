//
//  UdacityClient.swift
//  On The Map
//
//  Created by Warren Hansen on 9/26/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//  Login challenge - how to return  errors.... or accoundID + sessionID
//  also how to disable loging button durring completion of api call

import Foundation

typealias CompletionHandler = (_ result:AnyObject?,_ error: NSError?)-> Void

class UdacityClient {

    var registered: Bool? = nil
    var accountKey: String? = nil  // Account-Key
    var sessionID: String? = nil //Session-ID
    var expiration: String? = nil
    
    // MARK: Make Network Request on Udacity
    func logInToUdacity (user: String, password: String,  completionHandler: CompletionHandler) {
        
        // MARK: TODO: make this  taskForGet function
        // Build the URL, Configure the request
        let request = Constants.Udacity.APIBaseURL
        request.httpMethod = Constants.UdacityParameterValues.Method
        request.addValue(Constants.UdacityParameterKeys.AppJson, forHTTPHeaderField: Constants.UdacityParameterKeys.Accept)
        request.addValue(Constants.UdacityParameterKeys.AppJson, forHTTPHeaderField: Constants.UdacityParameterKeys.Content)
        request.httpBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        // aka task 3 types data, download, upload
        let session = URLSession.shared
        
        // 4 create network request
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String) {
                print(error)
                print("URL at time of error: \(request)")
                performUIUpdatesOnMain {
                    //dispatch_async(DISPATCH_QUEUE_PRIORITY_DEFAULT, { () -> Void in
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
            
            // MARK:  make this parseJSON Function
            // parse the data
            let parsedResult: [String:AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError(error: "Could not parse the data as JSON: '\(data)'")
                return
            }
            // MARK: TODO Make this getRequestToken func
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

        }
        task.resume()

    }
    
}




