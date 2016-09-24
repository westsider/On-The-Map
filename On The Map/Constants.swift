//
//  Constants.swift
//  On The Map
//
//  Created by Warren Hansen on 9/23/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

// MARK: - Constants
import UIKit

struct Constants {
    
    // MARK: Udacity
    struct Udacity {
        static let APIBaseURL = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
    }

    // MARK: Udacity Parameter Keys
    struct UdacityParameterKeys {
        
        static let AppJson = "application/json"
        static let Accept = "Accept"
        static let Content = "Content-Type"
        
      /*  static let Method = "Method"
        static let Accept = "Accept"
        static let Content = "Content-Type"
        static let JsonBody = ""
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback" */
    }

    // MARK: Udacity Parameter Values
    struct UdacityParameterValues {
        static let Method = "POST"
        static let Accept = "Accept"
        static let Content = "Content-Type"
        static let JsonBody = "{\"udacity\": {\"username\": \"whansen1@mac.com\", \"password\": \"wh2403wh\"}}"
    }
    
    // MARK: Udacity Response Keys
    struct UdacityResponseKeys {
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
    }
    
    // MARK: Udacity Response Values
    struct UdacityResponseValues {
        static let OKStatus = "ok"
    }
}

//request.httpMethod = "POST"
//let jsonBody = "{\"udacity\": {\"username\": \"whansen1@mac.com\", \"password\": \"wh2403wh\"}}"
//let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
//request.addValue("application/json", forHTTPHeaderField: "Accept")
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//  request.httpBody = jsonBody.data(using: String.Encoding.utf8)
//let jsonBody = Constants.UdacityParameterValues.JsonBody    }
