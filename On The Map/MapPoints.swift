//
//  MapPoints.swift
//  On The Map
//
//  Created by Warren Hansen on 10/2/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import Foundation

// Get student name location and url

class MapPoints: NSObject {
    
    
    //These shared keys are used by all students in Udacity.com's "iOS Networking with Swift" course.
    let ParseID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let ParseAPIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    
    //Database URL:
    let DatabaseURL: String = "https://parse.udacity.com/parse/classes"
    
    
    //Each point on the map is a StudentInformation object. They are stored in this array.
    var mapPoints = [StudentInformation]()
    
    
    //This will be set to true when a new pin is submitted to Parse.
    var needToRefreshData = false
    
    
    //Get student information from Parse.
    func fetchData(_ completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string:  "\(self.DatabaseURL)/StudentLocation")!)
        request.addValue(self.ParseID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //Initialize session.
        let session = URLSession.shared
        
        //Initialize task for data retrieval.
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if error != nil {
                completionHandler(false, error!.localizedDescription)
            }
            
            //Parse the data.
            let parsingError: NSError? = nil
            let parsedResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary
            
            if let error = parsingError {
                completionHandler(false, error.description)
                
            } else {
                if let results = parsedResult["results"] as? [[String : AnyObject]] {
                    
                    //Clear existing data from the mapPoints object.
                    self.mapPoints.removeAll(keepingCapacity: true)
                    
                    //Re-populate the mapPoints object with refreshed data.
                    for result in results {
                        self.mapPoints.append(StudentInformation(dictionary: result))
                    }
                    
                    //Setting this flag to true lets the TabViewController know that the views need to be reloaded.
                    self.needToRefreshData = true
                    
                    completionHandler(true, nil)
                } else {
                    completionHandler(false, "Could not find results in \(parsedResult)")
                }
            }
            
        })
        task.resume()
    }
    
    
    //Submit a student information node to Parse.
    func submitData(_ latitude: String, longitude: String, addressField: String, link: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "\(self.DatabaseURL)/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(self.ParseID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //API Parameters.
        request.httpBody = "{\"uniqueKey\": \"\(UdacityLogin.sharedInstance().userKey)\", \"firstName\": \"\(UdacityLogin.sharedInstance().firstName)\", \"lastName\": \"\(UdacityLogin.sharedInstance().lastName)\",\"mapString\": \"\(addressField)\", \"mediaURL\": \"\(link)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        //Initialize session.
        let session = URLSession.shared
        
        //Initialize task for data retrieval.
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            if error != nil {
                completionHandler(false, "Failed to submit data.")
            } else {
                completionHandler(true, nil)
            }
            
        })
        task.resume()
    }
    
    //  log out
    func logOut( completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: "\(self.DatabaseURL)/StudentLocation/UniqueObjectId")! as URL)
        request.httpMethod = "DELETE"
        request.addValue(self.ParseID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandler(false, "Failed to submit data.")
            } else {
                completionHandler(true, nil)
            }
        }
        task.resume()
    }
    
    //Allows other classes to reference a common instance of the mapPoints array.
    class func sharedInstance() -> MapPoints {
        
        struct Singleton {
            static var sharedInstance = MapPoints()
        }
        return Singleton.sharedInstance
    }
}
