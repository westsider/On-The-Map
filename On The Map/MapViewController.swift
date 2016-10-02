//
//  FirstViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 9/18/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
   // var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //episodes = Episode.downloadAllEpisodes()
        
    }

    fileprivate func loadMapData() {
        
        mapView.removeAnnotations(mapView.annotations)
        
        //  let students = StudentInformationModel.students
        
//        print("-----------<<<<<<<<<  S I M >>>>>>>>>>>>>--------------")
//                print(students)
//        
      //  var annotations = [MKPointAnnotation]()
        
//        for student in students {
//            
//            // get the appropriate information
//            let lat: Double = CLLocationDegrees(student.latitude)  // ! is my change
//            let long: Double = CLLocationDegrees(student.longitude)
//            
//            // The lat and long are used to create a CLLocationCoordinates2D instance.
//            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            
//            let first: String = student.firstName
//            let last: String = student.lastName
//            let mediaURL: String = student.mediaURL
//            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = "\(first) \(last)"
//            annotation.subtitle = mediaURL
//            
//            // add to to our array of annotations
//            annotations.append(annotation)
//        }
        
        // When the array is complete, we add the annotations to the map.
//        self.mapView.addAnnotations(annotations)
    }



}

