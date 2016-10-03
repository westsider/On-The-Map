//
//  TabViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 10/2/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    
//    @IBOutlet weak var refreshButton: UIBarButtonItem!
//    
//    @IBAction func tapRefreshButton(_ sender: AnyObject) {
////refreshData()
//    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //self.title = "On The Map"
        //self.navigationItem.title = "foo"
        //navigationBar.topItem.title = "Nav title"
        //self.tabBarController?.navigationItem.leftBarButtonItem = settingsButton
        
        //Checks to see if flag has been set to true by AddPinViewController.
        if MapPoints.sharedInstance().needToRefreshData {
            MapPoints.sharedInstance().needToRefreshData = false
//refreshData()
        }
    }
    
    
    //Reloads the data on the Map and Table views.
    func refreshData() {
        //The disabled refresh button indicates that the refresh is in progress.
// refreshButton.isEnabled = false
        
        //This function fetches the latest data from the server.
        MapPoints.sharedInstance().fetchData() { (success, errorString) in
            if !success {
                DispatchQueue.main.async(execute: {
                    let controller: UIAlertController = UIAlertController(title: "Error", message: "Error loading map data. Tap Refresh to try again.", preferredStyle: .alert)
                    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    
                    //The user can try refreshing again.
                    //self.refreshButton.isEnabled = true
                })
            } else {
                DispatchQueue.main.async(execute: {
                    if let viewControllers = self.viewControllers {
                        for viewController in viewControllers {
                            (viewController as! ReloadableTab).reloadViewController()
                        }
                    }
                    
                    //The re-enabled refresh button indicates that the refresh is complete.
                    //self.refreshButton.isEnabled = true
                })
            }
        }
    }
}

