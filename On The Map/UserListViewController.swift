//
//  UserList ViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 10/6/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Variables + Outlets
    @IBOutlet var myTableView: UITableView!
    
    @IBOutlet weak var logoutButton: UINavigationItem!
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    //# MARK: Add Pin To Map
    @IBAction func pinButtonAction(_ sender: AnyObject) {
        // see if user has a pin
        if thisUserPosted  {
            let thisAlert = "You Have Already Posted A Student Location. Would You Like to Overwrite Your Current Location?"
            showDoubleAlert(title: "Hey", message: thisAlert)
        } else {
            // if no user pin then segue to add pin VC  mapToPinSegue
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "listToPinController", sender: self)
            })
        }
    }
    
    // MARK: Set Up TableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  StudentData.sharedInstance().mapPoints.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mapPoint = StudentData.sharedInstance().mapPoints[(indexPath as NSIndexPath).row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = mapPoint.fullName
        cell.imageView?.image = UIImage(named: "pinB")
        return cell
    }
    
    // MARK:  Open Url when Row Selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlArray:[String] = []
        for result in StudentData.sharedInstance().mapPoints {
            urlArray.append(result.mediaURL)
        }
        // remove any spaces or add missing http in url string
        let cleanUrl = MapPoints.sharedInstance().cleanUrl(url: urlArray[indexPath.row])
        if cleanUrl == "" {
            // show alert that there is no URL
            SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Error", message: "No Url was Shared")
        } else {
            UIApplication.shared.openURL(URL(string: cleanUrl)!)
        }
    }
    
    // MARK: Reloads the data on the Map and Table views. EROOR UNWRAPPING OPTIONAL
    func refreshData() {
        //The disabled refresh button indicates that the refresh is in progress.
        setUIEnabled(enabled: false)
        //This function fetches the latest data from the server.
        MapPoints.sharedInstance().fetchData() { (success, errorString) in
            if !success {
                DispatchQueue.main.async(execute: {
                    SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Error Reloading Data", message: errorString!)
                    self.setUIEnabled(enabled: true)
                })
            }
            else {
                DispatchQueue.main.async(execute: {
                    // reload tableview
                    self.myTableView.reloadData()
                    self.setUIEnabled(enabled: true)
                })
            }
        }
    }
    
    //# MARK: Reload Data
    @IBAction func reloadTableViewAction(_ sender: AnyObject) {
        refreshData()
    }
    
    //# MARK: Log Out of Udacity and FaceBook
    @IBAction func logOutAction(_ sender: AnyObject) {
        setUIEnabled(enabled: false)
        logoutFacebook()
        MapPoints.sharedInstance().logOut() { (success, errorString) in
            if success {
                DispatchQueue.main.async(execute: {
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                self.setUIEnabled(enabled: true)
                SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Oh Snap!", message:errorString!)
            }
        }
    }
    
    // MARK: Configure UI
    private func setUIEnabled(enabled: Bool) {
        pinButton.isEnabled = true
        reloadButton.isEnabled = true
        
        if enabled {
            pinButton.isEnabled = true
            reloadButton.isEnabled = true
        } else {
            pinButton.isEnabled = false
            reloadButton.isEnabled = false
        }
    }
    
    //# MARK: Show special 2 Button Alert View Controller
    func showDoubleAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
        }
        let listToPinController = "listToPinController"
        let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: listToPinController, sender: self)
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(overwriteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //# MARK: Logout FaceBook
    func logoutFacebook() {
        if StudentData().isloggedInFacebook {
            FBSDKLoginManager().logOut()
        }
    }
}
