//
//  ViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/10/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
     var activityType = ActivityType.run
    
    @IBAction func swimButtonPressed(_ sender: Any) {
        activityType = .swim
        performSegue(withIdentifier: "activityView", sender: self)
    }
    
    @IBAction func bikeButtonPressed(_ sender: Any) {
        activityType = .bike
        performSegue(withIdentifier: "activityView", sender: self)
    }
    
    @IBAction func runButtonPressed(_ sender: Any) {
        activityType = .run
        performSegue(withIdentifier: "activityView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "activityView") {
            let tabVc = segue.destination as! UITabBarController
            let navVc = tabVc.viewControllers!.first as! UINavigationController
            let destinationVC = navVc.viewControllers.first as! ActivityViewController
            destinationVC.activityType = activityType
        }
    }


}

