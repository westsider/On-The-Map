//
//  addLocationViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 10/4/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//


import UIKit
import MapKit

class addLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    let linkViewToMapDisplaySegue = "linkViewToMapDisplaySegue"
    
    @IBOutlet weak var whereUstudyingToday: UITextView!
    
    @IBOutlet weak var enterLink: UITextField!
    
    @IBOutlet weak var enterLocation: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var submitLinkButton: UIButton!
    
    @IBOutlet weak var topViewBackgroung: UIView!
    
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
        
        //This is required to add "http://" to the linkField text field when a user starts typing, and to call a findOnMap() when the return key is pressed.
        enterLink.delegate = self
        
        //This is required to call the findOnMap() function when the return key is pressed.
        enterLocation.delegate = self
        
        //These items aren't revealed until the user successfully finds a location.
        mapView.isHidden = true
        topViewBackgroung.isHidden = true
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
    
    //Creates an Alert-style error message.
    func errorAlert(_ title: String, error: String) {
        let controller: UIAlertController = UIAlertController(title: title, message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    //Makes it easier for the user to enter a valid link.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == LINK_FIELD {
            textField.text = "http://"
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
//    // MARK: Lifecycle Function
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        subscribeToKeyboardNotifications()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        unSubscribeToKeyboardNotofications()
//    }
//    
//    // MARK:  Set up view shift up behavior for keyboard text entry
//    //  NSNotification subscriptions and selectors
//    func subscribeToKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(LogOnViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(LogOnViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    func unSubscribeToKeyboardNotofications() {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//    
//    // MARK: shift the view's frame up only on bottom text field
//    func keyboardWillShow(notification: NSNotification) {
//        if userPassword.isFirstResponder && view.frame.origin.y == 0.0{
//            view.frame.origin.y -= getKeyboardHeight(notification: notification)
//        }
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if userPassword.isFirstResponder {
//            view.frame.origin.y = 0
//        }
//    }
//    
//    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
//        return keyboardSize.cgRectValue.height
//    }
//    
//    // MARK: hide keyboard with return or on click away from text
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        view.endEditing(true)
//        return false
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
    
}
