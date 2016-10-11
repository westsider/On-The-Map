//
//  StudentData.swift
//  On The Map
//
//  Created by Warren Hansen on 10/11/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import Foundation

class StudentData: NSObject {
    //Each point on the map is a StudentInformation object. They are stored in this array.
    var mapPoints = [StudentInformation]()
    
    //Allows other classes to reference a common instance of the mapPoints array.
    class func sharedInstance() -> StudentData {
        
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }
}
