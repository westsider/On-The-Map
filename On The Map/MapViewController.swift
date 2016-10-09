//
//  FirstViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 9/18/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Variables + Outlets
    var thisUserPosted = false
    
    let mapToPinSegue = "mapToPinSegue"
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var activityCircle:
    UIActivityIndicatorView!
    
    //# MARK: Add Pin To Map
    @IBAction func tapPinButton(_ sender: AnyObject) {
        // see if user has a pin
        if thisUserPosted {
            let thisAlert = "You Have Already Posted A Student Location. Would You Like to Overwrite Your Current Location?"
            let alertController = UIAlertController(title: "Hey", message: thisAlert, preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                print("Cancel")
            }
            let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                print("Overwrite")
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: self.mapToPinSegue, sender: self)
                })
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(overwriteAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            // if no user pin then segue to add pin VC  mapToPinSegue
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: self.mapToPinSegue, sender: self)
            })
        }
    }
    
    //# MARK: Refresh Map
    @IBAction func tapRefreshButton(_ sender: AnyObject) {
        refreshData()
    }

    //# MARK: Open mediaURL in Safari when the annotation info box is tapped.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        UIApplication.shared.openURL(URL(string: view.annotation!.subtitle!!)!)
    }
    
    //# MARK: "callout" to annotation so it can access the mediaURL.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapAnnotation")
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        return view
    }
    
    //# MARK: Logout
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        self.setUIEnabled(enabled: false)
        MapPoints.sharedInstance().logOut() { (success, errorString) in
            if success {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "LogOnStoryEntry") //as! UIViewController
                self.present(controller, animated: true, completion: nil)
            } else {
                self.setUIEnabled(enabled: true)
                SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Oh Snap!", message: errorString!)
            }
        }
    }
    
    //# MARK: Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets the map area.
        mapView?.camera.altitude = 200000;
        //Set map to center on Los Angeles
        mapView?.centerCoordinate = CLLocationCoordinate2D(latitude: 34.052235, longitude: -118.243683)
        //Adding a link to the annotation requires making the mapView a delegate of MKMapView.
        mapView.delegate = self
        //Call to getStudents then Draw the annotations on the map.
        reloadViewController()
    }
    
    //# MARK: Required to conform to the ReloadableTab protocol.
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
            
            // flag that this user is on the map
            if result.fullName == UdacityLogin.sharedInstance().firstName + " " + UdacityLogin.sharedInstance().lastName {
                thisUserPosted = true
                print(" ")
                print("<<<<<<<<< THIS USER HAS POSTED TO MAP >>>>>>>>>>>>>>>>>>>>>")
                print(" ")
            }
            
            
            //Adds the annotation to the map.
            mapView.addAnnotation(annotation)
        }
        activityCircle.stopAnimating()
    }
    
    //# MARK: Reloads the data on the Map
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
    
    //# MARK: Configure UI
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
