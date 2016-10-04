//
//  FirstViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 9/18/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.

//  need to gaurd against bad urls
//  add pin function
//  add logout


import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var activityCircle:
    UIActivityIndicatorView!
    
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
    }
  
    @IBAction func tapPinButton(_ sender: AnyObject) {
    }
    
    @IBAction func tapRefreshButton(_ sender: AnyObject) {
        refreshData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //Sets the map area.
        mapView?.camera.altitude = 500000;
        //Set map to center on Los Angeles
        mapView?.centerCoordinate = CLLocationCoordinate2D(latitude: 34.052235, longitude: -118.243683)
        //Adding a link to the annotation requires making the mapView a delegate of MKMapView.
        mapView.delegate = self
        //Call to getStudents then Draw the annotations on the map.
        reloadViewController()
    }
    
    
    //Opens the mediaURL in Safari when the annotation info box is tapped.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        UIApplication.shared.openURL(URL(string: view.annotation!.subtitle!!)!)
    }
    
    
    //Adds a "callout" to the annotation info box so that it can be tapped to access the mediaURL.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapAnnotation")
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        return view
    }
    
    
    //Required to conform to the ReloadableTab protocol.
    func reloadViewController() {
        activityCircle.startAnimating()
        for result in MapPoints.sharedInstance().mapPoints {
            
            //Creates an annotation and coordinate.
            let annotation = MKPointAnnotation()
            let location = CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude)
            
            //Sets the coordinates of the annotation.
            annotation.coordinate = location
            
            //Adds a student name and URL to the annotation.
            annotation.title = result.fullName
            annotation.subtitle = result.mediaURL
            
            //Adds the annotation to the map.
            mapView.addAnnotation(annotation)
        }
        activityCircle.stopAnimating()
    }
    
    //Reloads the data on the Map and Table views.
    func refreshData() {
        //The disabled refresh button indicates that the refresh is in progress.
        setUIEnabled(enabled: false)
        //This function fetches the latest data from the server.
        MapPoints.sharedInstance().fetchData() { (success, errorString) in
            if !success {
                DispatchQueue.main.async(execute: {
                    let controller: UIAlertController = UIAlertController(title: "Error", message: "Error loading map data. Tap Refresh to try again.", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    
                    //The user can try refreshing again.
                    self.setUIEnabled(enabled: true)
                })
            }
           else {
               
                self.reloadViewController() 
                //The re-enabled refresh button indicates that the refresh is complete.
                self.setUIEnabled(enabled: true)
             
            }
        }
    }
    // MARK: Configure UI
    private func setUIEnabled(enabled: Bool) {
        refreshButton.isEnabled = true
        pinButton.isEnabled = true
        logoutButton.isEnabled = true
        
        if enabled {
            refreshButton.isEnabled = true
            pinButton.isEnabled = true
            logoutButton.isEnabled = true
            activityCircle.stopAnimating()
        } else {
            refreshButton.isEnabled = false
            pinButton.isEnabled = false
            logoutButton.isEnabled = false
            activityCircle.startAnimating()
        }
    }
    
}
