//
//  UdacityClient.swift
//  On The Map
//
//  Created by Warren Hansen on 9/26/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//  break it down into functions
//  login, parse, getuserID, geAccountInfo

import Foundation

typealias CompletionHandler = (_ result:String?,_ error: String?)-> Void

class UdacityClient {

    var registered: Bool? = nil
    var accountKey: String? = nil   // Account-Key
    var sessionID: String? = nil    //Session-ID
    var expiration: String? = nil
    var apiError:String? = nil
    
    // MARK: Make Network Request on Udacity
    func logInToUdacity (user: String, password: String,  completionHandler: @escaping CompletionHandler) {
        
        // Build the URL, Configure the request
        let request = urlRequest(user: user, password: password)
        let session = URLSession.shared
        
        // create network request
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // if an error occurs, send to and re-enable the UI
            func displayError(error: String) {
                print("\(error) ---> URL at time of error: \(request)")
                performUIUpdatesOnMain {
                    self.apiError = "API Error: " + error
                    completionHandler(nil, error)
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
            // remove security characters + parse the data
            let newData = self.truncate(data: data)
            let parsedResult: [String:AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError(error: "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // get account key and sessionID
            self.parseAccountKey(json: parsedResult)
            let sessionIDStr = self.parseSessionID(json: parsedResult)
            completionHandler(sessionIDStr, nil)
        }
        task.resume()
    }
   
    func parseAccountKey(json:[String:AnyObject]) {
        if let jsonResult = json["account"] as? [String: AnyObject] {
            self.accountKey = jsonResult["key"] as? String
            print("Account-Key: \(self.accountKey!)")
            print(" ")
        }
    }
    
    func parseSessionID(json: [String:AnyObject]) -> String {
        if let jsonResult = json["session"] as? [String: AnyObject] {
            self.sessionID = jsonResult["id"] as? String
            print("Session-ID: \(self.sessionID!)")
            print(" ")
        }
        return "Swift 3.0 API Login Successful! \r\n\r\nAccount-Key: \(self.accountKey!) \r\n\r\nSession-ID: \(self.sessionID!)"
    }
    
    func urlRequest(user: String, password: String)-> NSMutableURLRequest {
        let request = Constants.Udacity.APIBaseURL
        request.httpMethod = Constants.UdacityParameterValues.Method
        request.addValue(Constants.UdacityParameterKeys.AppJson, forHTTPHeaderField: Constants.UdacityParameterKeys.Accept)
        request.addValue(Constants.UdacityParameterKeys.AppJson, forHTTPHeaderField: Constants.UdacityParameterKeys.Content)
        request.httpBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        return request
    }
    
    func truncate(data:Data) -> Data {
        let dataLength = data.count
        let r = 5...Int(dataLength)
        return  data.subdata(in: Range(r)) /* subset response data! */
    }

}




