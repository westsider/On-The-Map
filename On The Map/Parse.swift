//
//  Parse.swift
//  On The Map
//
//  Created by Warren Hansen on 10/1/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//
/*
    references from:
    https://discussions.udacity.com/t/is-the-parse-database-down/181702/7
 
    current Parse path 9/30/2016 :
    https://parse.udacity.com/parse/classes
*/
import Foundation
import UIKit

struct Parse {
    
    // notification names
    static let parseRetrievalDidCompleteNotification = "parseRetrievalDidComplete"
    static let parseRetrievalDidFailNotification = "parseRetrievalDidFail"
    static let parsePostDidCompleteNotification = "parsePostDidComplete"
    static let parsePostDidFailNotification = "parsePostDidFail"
    static let parsePutDidCompleteNotification = "parsePutDidComplete"
    static let parsePutDidFailNotification = "parsePutDidFail"
    
    // dictionary keys
    static let messageKey = "message"
    static let resultsKey = "results"
    
    // request keys
    fileprivate let apiHost = "parse.udacity.com"
    fileprivate let apiPath = "/parse/classes/StudentLocation"
    fileprivate let getMethod = "GET"
    fileprivate let postMethod = "POST"
    fileprivate let putMethod = "PUT"
    fileprivate let parseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    fileprivate let parseRESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    fileprivate let jsonContentType = "application/json"
    fileprivate let xParseApplicationId = "X-Parse-Application-Id"
    fileprivate let xParseRESTAPIKey = "X-Parse-REST-API-Key"
    fileprivate let xParseContentTypeKey = "Content-Type"
    
    fileprivate let limitParm = "limit"
    fileprivate let limitValue = "100"
    fileprivate let orderParm = "order"
    fileprivate let orderValue = "-updatedAt"
    fileprivate let apiScheme = "https"
    
    // failure messages
    fileprivate let invalidRequestURLMessage = "Invalid request URL."
    fileprivate let networkUnreachableMessage = "Network connection is not available."
    fileprivate let errorReceivedMessage = "An error was received:\n"
    fileprivate let badStatusCodeMessage = "Unable to retrieve data from server."
    fileprivate let locationDataUnavailableMessage = "Location data is unavailable."
    fileprivate let unableToParseDataMessage = "Unable to parse received data."
    fileprivate let jsonSerializationFailureMessage = "Unable to convert post data to JSON format."
    fileprivate let noDataReceivedMessage = "No data received from Parse server."
    fileprivate let invalidDataReceivedMessage = "Invalid data received from Parse server."

    
    func createURLFromParameters(_ parameters: [String:AnyObject]?, pathExtension: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = apiScheme
        components.host = apiHost
        components.path = ("\(apiPath)/\(pathExtension ?? "")")
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    func retrieveMapData() {
        
        let methodParameters = [
            limitParm: limitValue,
            orderParm: orderValue
        ]
        
        let requestURL = createURLFromParameters(methodParameters as [String : AnyObject]?, pathExtension: nil)
        var request = URLRequest(url: requestURL)
        
        request.addValue(parseApplicationId, forHTTPHeaderField: xParseApplicationId)
        request.addValue(parseRESTAPIKey, forHTTPHeaderField: xParseRESTAPIKey)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            
            (data, response, error) in
            
            guard error == nil else {
                print("<<<<<<< ERROR >>>>>>>>>>")
                print(error)
//                let errorMessage = (error as! NSError).userInfo[NSLocalizedDescriptionKey] as! String
//                let failureMessage = self.errorReceivedMessage + "\(errorMessage)"
//                self.postFailureNotification(Parse.parseRetrievalDidFailNotification, failureMessage: failureMessage)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode != 200 {
                print("<<<<<<< STATUS CODE ERROR >>>>>>>>>>")
                print(error)
//                let failureMessage = self.badStatusCodeMessage + " (\(statusCode))"
//                self.postFailureNotification(Parse.parseRetrievalDidFailNotification, failureMessage: failureMessage)
                return
            }
           
            guard let data = data else {
                print("<<<<<<< DATA ERROR >>>>>>>>>>")
                print(error)
                //self.postFailureNotification(Parse.parseRetrievalDidFailNotification, failureMessage: self.locationDataUnavailableMessage)
                return
            }
            /*
             let parsedResult: [String:AnyObject]
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
                    } catch {
                    displayError(error: "Could not parse the data as JSON: '\(data)'")
                return
                }
            */
            let options = JSONSerialization.ReadingOptions()
//            let parsedData: [String:AnyObject]
//            let results: [String:AnyObject]
//            do {
//                parsedData = try JSONSerialization.jsonObject(with: data, options: options) as! [String: AnyObject]
//                //results = parsedData[Parse.resultsKey] as? [[String: AnyObject]]
//            } catch {
//                    print("<<<<<<< PARSE ERROR >>>>>>>>>>")
//                    print(error)
//                    //self.postFailureNotification(Parse.parseRetrievalDidFailNotification, failureMessage: self.unableToParseDataMessage)
//                    return
//            }
            guard let parsedData = try? JSONSerialization.jsonObject(with: data, options: options) as! [String: AnyObject],
                let results = parsedData[Parse.resultsKey] as? [[String: AnyObject]] else {
                    print("<<<<<<< PARSE ERROR >>>>>>>>>>")
                    print(error)
                    //self.postFailureNotification(Parse.parseRetrievalDidFailNotification, failureMessage: self.unableToParseDataMessage)
                    return
            }
            
            print("<<<<<<<<<<< inside Retrive Map Data >>>>>>>>>")
            print(parsedData)
            print("<<<<<<<<<<< sending Parsed pata to S I M     >>>>>>>>>")
            print(results)
            print("<<<<<<<<<<< sending results pata to S I M     >>>>>>>>>")
            //StudentInformationModel.populateStudentList(withStudents: results)
//print("<<<<<<< StudentInformationModel.populateStudentList(withStudents: results)  >>>>>>>>>>")
            //NotificationCenter.postNotificationOnMain(Parse.parseRetrievalDidCompleteNotification, userInfo: nil)
        })
        task.resume()
        
        // next go to map view and check for data
    }
}

// Ducs pars to dictionary
// 1 change init
// 2 figure out ho to call it
class Episode
{
    var title: String?
    var description: String?
    var thumbnailURL: URL?
    var createdAt: String?
    var author: String?
    var url: URL?
    
    init(title: String, description: String, thumbnailURL: URL, createdAt: String, author: String)
    {
        self.title = title
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.createdAt = createdAt
        self.author = author
    }
    
    init(espDictionary: [String : AnyObject])
    {
        self.title = espDictionary["title"] as? String
        description = espDictionary["description"] as? String
        thumbnailURL = URL(string: espDictionary["thumbnailURL"] as! String)
        self.createdAt = espDictionary["pubDate"] as? String
        self.author = espDictionary["author"] as? String
        self.url = URL(string: espDictionary["link"] as! String)
    }
    
    static func downloadAllEpisodes() -> [Episode]
    {
        var episodes = [Episode]()
        
        let jsonFile = Bundle.main.path(forResource: "DucBlog", ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonFile!))
        
        // turn the data into foundation objects (Episodes)
        if let jsonDictionary = NetworkService.parseJSONFromData(jsonData) {
            let espDictionaries = jsonDictionary["episodes"] as! [[String : AnyObject]]
            for espDictionary in espDictionaries {
                let newEpisode = Episode(espDictionary: espDictionary)
                episodes.append(newEpisode)
            }
        }
        
        return episodes
    }
    
}
class NetworkService
{
    static func parseJSONFromData(_ jsonData: Data?) -> [String : AnyObject]?
    {
        if let data = jsonData {
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
                return jsonDictionary
                
            } catch let error as NSError {
                print("error processing json data: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
}
