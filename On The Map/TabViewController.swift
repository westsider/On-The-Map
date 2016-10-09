//
//  TabViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 10/2/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //Checks to see if flag has been set to true by AddPinViewController.
        if MapPoints.sharedInstance().needToRefreshData {
            MapPoints.sharedInstance().needToRefreshData = false
        }
    }
    
}
