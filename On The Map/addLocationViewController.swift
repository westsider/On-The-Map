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
    
    // MARK: Variables + Outlets
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
    
    // MARK:  Geocode Location
    func findOnMap() {
        setUIEnabled(enabled: false)
        let location = enterLocation.text
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location!, completionHandler: { (placemarks, error) -> Void in
            //Returns an error if geocoding is unsuccessful.
            if ((error) != nil) {
                DispatchQueue.main.async(execute: {
                    SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Geocode Error", message: "Please enter a valid location")
                })
                self.setUIEnabled(enabled: true)
            }
                //If geocoding is successful, multiple locations may be returned in an array. Only the first location is used below.
            else if placemarks?[0] != nil {
                self.revealMap()
                let placemark: CLPlacemark = placemarks![0]
                //Creats a coordinate and annotation.
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = coordinates
                self.displayMap()
                self.mapView?.addAnnotation(pointAnnotation)
                self.mapView?.centerCoordinate = coordinates
                self.mapView?.camera.altitude = 20000;
                self.coordinates = coordinates
                self.displayLocation()
            }
        })
    }
    
    // MARK:  Ensure url is valid
    func validateUrl(_ url: String) -> Bool {
        let pattern = "^(https?:\\/\\/)([a-zA-Z0-9_\\-~]+\\.)+[a-zA-Z0-9_\\-~\\/\\.]+$"
        if url.range(of: pattern, options: .regularExpression) != nil {
            return true
        }
        return false
    }
    
    // MARK:  Ensure secure url
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == Constants.LINK_FIELD {
            textField.text = "https://"
        }
    }
    
    //MARK: Submit URL Link
    @IBAction func submitLinkAction(_ sender: AnyObject) {
        
        if validateUrl(enterLink.text!) == false {
            SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Invalid URL", message: "Please enter a valid Url")
        } else {
            activityIndicator.color = UIColor.darkGray
            setUIEnabled(enabled: false)
            //Submits the new data point.
            MapPoints.sharedInstance().submitData(coordinates.latitude.description, longitude: coordinates.longitude.description,
                                                  addressField: enterLink.text!, link: enterLink.text!) { (success, errorString) in
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
                                                            SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Location Post Error", message: errorString!)
                                                        })
                                                    }
            }
        }
    }
    
    // MARK: Cancel
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK:  URL Post Complete Segue Back To Map View
    func completePosing() {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: Constants.linkViewToMapDisplaySegue, sender: self)
        })
    }
    
    //MARK:  Lifrcycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        enterLink.tag = Constants.LINK_FIELD
        //This is required to add "https://" to the linkField
        enterLink.delegate = self
        enterLocation.delegate = self
        displayOriginalUI()
        modifyText()
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
        enterLocation.isEnabled = true
        submitLinkButton.isEnabled = true
        findOnMapButton.isEnabled = true
        activityIndicator.stopAnimating()
        
        if enabled {
            whereUstudyingToday.alpha = 1.0
            enterLocation.alpha = 1.0
            submitLinkButton.alpha = 1.0
            findOnMapButton.alpha = 1.0
            mapView.alpha = 1.0
            activityIndicator.stopAnimating()
        } else {
            whereUstudyingToday.alpha = 0.3
            enterLocation.alpha = 0.3
            submitLinkButton.alpha = 0.3
            findOnMapButton.alpha = 0.3
            mapView.alpha = 0.5
            activityIndicator.startAnimating()
        }
    }
    
    // MARK: Frist UI Set UP
    func displayOriginalUI(){
        //These items aren't revealed until the user successfully finds a location.
        mapView.isHidden = true
        topViewBackgroung.isHidden = false
        topViewBackgroung.backgroundColor = Constants.myLtGrayColor
        submitLinkButton.isHidden = true
        enterLink.isHidden = true
        activityIndicator.stopAnimating()
    }
    func revealMap() {
        self.midViewBackground.isHidden = true
        self.topViewBackgroung.backgroundColor = Constants.myBlueColor
        self.BottomViewBackground.isHidden = true
    }
    
    func displayMap(){
        self.mapView.isHidden = false
        self.topViewBackgroung.isHidden = false
    }
    
    func displayLocation() {
        //Items used to look for a location are hidden.
        self.findOnMapButton.isHidden = true
        self.enterLocation.isHidden = true
        
        //The keyboad is dismissed.
        self.enterLocation.resignFirstResponder()
        self.enterLink.resignFirstResponder()
        
        //The user can now submit the link.
        self.submitLinkButton.isHidden = false
        self.enterLink.isHidden = false
        self.whereUstudyingToday.isHidden = true
        self.setUIEnabled(enabled: true)
    }
    
    // MARK: Set Top Text Field
    func modifyText() {
        let string = "Where are you\rstudying\rtoday?"
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let fontSize:CGFloat = 28.0
        
        let attributes = [
            NSFontAttributeName: UIFont(name: "Helvetica",size: fontSize)!,
            NSParagraphStyleAttributeName: style,
            NSForegroundColorAttributeName: UIColor.lightGray
        ]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        
        attributedString.addAttribute(NSFontAttributeName,
                                      value: UIFont(name: "Helvetica-Bold",size: fontSize)!,
                                      range: NSRange(location: 14,length: 9))
        attributedString.addAttribute( NSForegroundColorAttributeName,
                                       value: UIColor.darkGray,
                                       range: NSRange(location:14,length:9))
        whereUstudyingToday.attributedText = attributedString
    }
}
