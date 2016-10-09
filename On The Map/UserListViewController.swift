//
//  UserListViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 10/6/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Variables + Outlets
    @IBOutlet var myTableView: UITableView!
    
    @IBOutlet weak var logoutButton: UINavigationItem!
    
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    
    @IBAction func logOutAction(_ sender: AnyObject) {
        setUIEnabled(enabled: false)
        MapPoints.sharedInstance().logOut() { (success, errorString) in
            if success {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "LogOnStoryEntry") //as! UIViewController
                self.present(controller, animated: true, completion: nil)
            } else {
                self.setUIEnabled(enabled: true)
                SPSwiftAlert.sharedObject.showNormalAlert(controller: self, title: "Oh Snap!", message:errorString!)
            }
        }
    }
    // MARK: Set Up TableView
    @IBAction func reloadTableViewAction(_ sender: AnyObject) {
        refreshData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MapPoints.sharedInstance().mapPoints.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mapPoint = MapPoints.sharedInstance().mapPoints[(indexPath as NSIndexPath).row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = mapPoint.fullName
        cell.imageView?.image = UIImage(named: "pinB")
        return cell
    }
    
    // MARK:  Open Url when Row Selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlArray:[String] = []
        for result in MapPoints.sharedInstance().mapPoints {
            urlArray.append(result.mediaURL)
        }
        UIApplication.shared.openURL(URL(string: urlArray[indexPath.row])!)
    }
    
    // MARK: Reloads the data on the Map and Table views.
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
                // reload tableview
                self.reloadViewController()
                //The re-enabled refresh button indicates that the refresh is complete.
                self.setUIEnabled(enabled: true)
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

    // Required to conform to the ReloadableTab protocol.
    func reloadViewController() {
        myTableView.reloadData()
    }
    
}
