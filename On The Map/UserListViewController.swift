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
                self.errorAlert("Oh Snap!", error: errorString!)
            }
        }
    }
    
    @IBAction func reloadTableViewAction(_ sender: AnyObject) {
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

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //Creates an Alert View Controller error message.
    func errorAlert(_ title: String, error: String) {
        let controller: UIAlertController = UIAlertController(title: title, message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}
