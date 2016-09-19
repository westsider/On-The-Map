//
//  Functions From Class.swift
//  On The Map
//
//  Created by Warren Hansen on 9/18/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import Foundation
import UIKit

// MARK: get Image to display

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create url
        let imageURL = URL(string: Constants.CatURL)!
        
        // create network request
        let task = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
            
            if error == nil {
                
                // create image
                let downloadedImage = UIImage(data: data!)
                
                // update UI on a main thread
                performUIUpdatesOnMain {
                    self.imageView.image = downloadedImage
                }
                
            } else {
                print(error)
            }
        }) 
        
        // start network request
        task.resume()
    }
}


import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

// MARK: - Constants

struct Constants {
    static let CatURL = "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg"
    static let PuppyURL = "http://www.puppiesden.com/pics/1/poodle-puppy2.jpg"
}

