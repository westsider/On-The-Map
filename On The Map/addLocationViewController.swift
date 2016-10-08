//
//  addLocationViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 10/4/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.

import UIKit
import MapKit

class addLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    let linkViewToMapDisplaySegue = "linkViewToMapDisplaySegue"
    let returnToStartOfPin = "mapToPinSegue"
    let myBlueColor = UIColor(red: 69.0/255.0, green: 130.0/214.0, blue: 214.0/255.0, alpha: 1.0)
    let myLtGrayColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    let LINK_FIELD = 1
    
    var coordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var whereUstudyingToday: UITextView!
    
    @IBOutlet weak var enterLink: UITextField!
    
    @IBOutlet weak var enterLocation: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var submitLinkButton: UIButton!
    
    @IBOutlet weak var topViewBackgroung: UIView!
    
    @IBOutlet weak var midViewBackground: UIView!
    
    @IBOutlet weak var BottomViewBackground: UIView!
    
    @IBOutlet weak var findOnMapButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:  Find Location On Map
    @IBAction func findOnMapAction(_ sender: AnyObject) {
        findOnMap()
    }
    
    //MARK:  Geocode Location
    func findOnMap() {
        //Indicates the geocoding is in process.
//activityIndicator.isHidden = false
setUIEnabled(enabled: false)
        let location = enterLocation.text
        let geocoder: CLGeocoder = CLGeocoder()
        
        //Geocodes the location.
        geocoder.geocodeAddressString(location!, completionHandler: { (placemarks, error) -> Void in
            //Returns an error if geocoding is unsuccessful.
            if ((error) != nil) {
                DispatchQueue.main.async(execute: {
                    SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Geocode Error", message: "Please enter a valid location")
                })
                //self.enterLocation.text = "Please enter a valid location"
                self.setUIEnabled(enabled: true)
            }
            //If geocoding is successful, multiple locations may be returned in an array. Only the first location is used below.
            else if placemarks?[0] != nil {
                
                // reveal map
                self.midViewBackground.isHidden = true
                self.topViewBackgroung.backgroundColor = self.myBlueColor
                self.BottomViewBackground.isHidden = true
                
                let placemark: CLPlacemark = placemarks![0]
                
                //Creats a coordinate and annotation.
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coordinates
                
                //Displays the map.
                self.mapView.isHidden = false
                self.topViewBackgroung.isHidden = false
                
                //Places the annotation on the map.
                self.mapView?.addAnnotation(pointAnnotation)
                
                //Centers the map on the coordinates.
                self.mapView?.centerCoordinate = coordinates
                
                //Sets the zoom level on the map.
                self.mapView?.camera.altitude = 20000;
                
                //Sets the coordinates parameter that is used if the user decides to submit this location.
                self.coordinates = coordinates
                
                //Items used to look for a location are hidden.
                self.findOnMapButton.isHidden = true
                self.enterLocation.isHidden = true
                
                //The keyboad is dismissed.
                self.enterLocation.resignFirstResponder()
                
                //This is necessary because the user may have moved his cursor to the linkField text field.
                self.enterLink.resignFirstResponder()
                
                //The user can now submit the location.
                self.submitLinkButton.isHidden = false
                self.enterLink.isHidden = false
                self.whereUstudyingToday.isHidden = true
                self.setUIEnabled(enabled: true)
            }
        })
    }
    
    //MARK: Submit URL Link
    @IBAction func submitLinkAction(_ sender: AnyObject) {
        
        if validateUrl(enterLink.text!) == false {
             SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Invalid URL", message: "Please enter a valid Url")
        } else {

            setUIEnabled(enabled: false)
            //Submits the new data point.
            MapPoints.sharedInstance().submitData(coordinates.latitude.description, longitude: coordinates.longitude.description, addressField: enterLink.text!, link: enterLink.text!) { (success, errorString) in
                if success {
                    DispatchQueue.main.async(execute: {
                        MapPoints.sharedInstance().needToRefreshData = true
                        self.dismiss(animated: true, completion: nil)
                        self.completePosing()
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        //If there is an error, the submit button is unhidden so that the user can try again.
                        self.setUIEnabled(enabled: true)
                        print("")
                        print("<<<<<<<<<<< geocode fail >>>>>>>>>>>>>>>")
                        SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Location Post Error", message: errorString!)
                    })
                }
            }
        }
    }
    
    //MARK:  Ensure secure url
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == LINK_FIELD {
            textField.text = "https://"
        }
    }
    
    //MARK:  Ensure url is valid
    func validateUrl(_ url: String) -> Bool {
        let pattern = "^(https?:\\/\\/)([a-zA-Z0-9_\\-~]+\\.)+[a-zA-Z0-9_\\-~\\/\\.]+$"
        if url.range(of: pattern, options: .regularExpression) != nil {
            return true
        }
        return false
    }
    
    //MARK:  URL Post Complete Segue Bacl To Map View
    func completePosing() {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: self.linkViewToMapDisplaySegue, sender: self)
        })
    }

    //MARK:  Lifrcycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        enterLink.tag = LINK_FIELD
        //This is required to add "https://" to the linkField
        enterLink.delegate = self
        enterLocation.delegate = self
        //These items aren't revealed until the user successfully finds a location.
        mapView.isHidden = true
        topViewBackgroung.isHidden = false
        topViewBackgroung.backgroundColor = myLtGrayColor
        submitLinkButton.isHidden = true
        enterLink.isHidden = true
        activityIndicator.stopAnimating()
    }

    // MARK: hide keyboard with return or on click away from text
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Configure UI
    private func setUIEnabled(enabled: Bool) {
        //whereUstudyingToday.isEnabled = true
        enterLocation.isEnabled = true
        submitLinkButton.isEnabled = true
        findOnMapButton.isEnabled = true
        activityIndicator.stopAnimating()
        
        if enabled {
            whereUstudyingToday.alpha = 1.0
            enterLocation.alpha = 1.0
            submitLinkButton.alpha = 1.0
            findOnMapButton.alpha = 1.0
            activityIndicator.stopAnimating()
        } else {
            whereUstudyingToday.alpha = 0.3
            enterLocation.alpha = 0.3
            submitLinkButton.alpha = 0.3
            findOnMapButton.alpha = 0.3
            activityIndicator.startAnimating()
        }
    }

}

