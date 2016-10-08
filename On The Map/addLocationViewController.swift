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
    let myBlueColor = UIColor(red: 69.0/255.0, green: 130.0/214.0, blue: 214.0/255.0, alpha: 1.0)
    let myLtGrayColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    
    @IBOutlet weak var whereUstudyingToday: UITextView!
    
    @IBOutlet weak var enterLink: UITextField!
    
    @IBOutlet weak var enterLocation: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var submitLinkButton: UIButton!
    
    @IBOutlet weak var topViewBackgroung: UIView!
    
    @IBOutlet weak var midViewBackground: UIView!
    
    @IBAction func submitLinkAction(_ sender: AnyObject) {
        
        if validateUrl(enterLink.text!) == false {
            errorAlert("Invalid URL", error: "Please try again.")
        } else {
            
            //Prevents user from submitting twice.
            submitLinkButton.isHidden = true
            
            //Indicates that the app is working
            //workingMessage.isHidden = false
            
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
                        self.submitLinkButton.isHidden = false
                        //self.workingMessage.isHidden = true
                        self.errorAlert("Error", error: errorString!)
                    })
                }
            }
        }
    }
    @IBOutlet weak var BottomViewBackground: UIView!
    
    // mapDisplay
    
    func completePosing() {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: self.linkViewToMapDisplaySegue, sender: self)
        })
    }
    
    @IBOutlet weak var findOnMapButton: UIButton!
    
    @IBAction func findOnMapAction(_ sender: AnyObject) {
        findOnMap()
    }
    
   	let LINK_FIELD = 1
    
    var coordinates: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterLink.tag = LINK_FIELD
        //This is required to add "https://" to the linkField
        enterLink.delegate = self
        enterLocation.delegate = self
        
        //These items aren't revealed until the user successfully finds a location.
        mapView.isHidden = true
        //topViewBackgroung.isHidden = true
        topViewBackgroung.isHidden = false
        topViewBackgroung.backgroundColor = myLtGrayColor
        submitLinkButton.isHidden = true
        enterLink.isHidden = true
        //workingMessage.isHidden = true
    }
    
    func findOnMap() {
        
        //Indicates the geocoding is in process.
        //workingMessage.isHidden = false
        
        let location = enterLocation.text
        let geocoder: CLGeocoder = CLGeocoder()
        
        //Geocodes the location.
        geocoder.geocodeAddressString(location!, completionHandler: { (placemarks, error) -> Void in
            
            // reveal map
            self.midViewBackground.isHidden = true
            self.topViewBackgroung.backgroundColor = self.myBlueColor
            self.BottomViewBackground.isHidden = true
            //Returns an error if geocoding is unsuccessful.
            if ((error) != nil) {
                //self.workingMessage.isHidden = true
                self.errorAlert("Invalid location", error: "Please try again.")
            }
                
                //If geocoding is successful, multiple locations may be returned in an array. Only the first location is used below.
            else if placemarks?[0] != nil {
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
                self.mapView?.camera.altitude = 1000;
                
                //Sets the coordinates parameter that is used if the user decides to submit this location.
                self.coordinates = coordinates
                
                //Items used to look for a location are hidden.
                //self.workingMessage.isHidden = true
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
                
            }
        })
    }
    
    //Creates an Alert View Controller error message.
    func errorAlert(_ title: String, error: String) {
        let controller: UIAlertController = UIAlertController(title: title, message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    //Makes it easier for the user to enter a valid link.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == LINK_FIELD {
            textField.text = "https://"
        }
    }
    
    //Regular expression used for validating submitted URLs.
    func validateUrl(_ url: String) -> Bool {
        let pattern = "^(https?:\\/\\/)([a-zA-Z0-9_\\-~]+\\.)+[a-zA-Z0-9_\\-~\\/\\.]+$"
        if url.range(of: pattern, options: .regularExpression) != nil {
            return true
        }
        return false
    }
    
    // MARK: hide keyboard with return or on click away from text
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

