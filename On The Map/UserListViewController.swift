//
//  UserListViewController.swift
//  On The Map
//
//  Created by Warren Hansen on 10/6/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tavleView: UITableView!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
