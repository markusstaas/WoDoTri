//
//  ViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/10/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let workoutData = WorkoutData.shared
    
    @IBAction func bikeButtonPressed(_ sender: Any) {
        workoutData.activityType = .bike
        performSegue(withIdentifier: "ActivityPageViewController", sender: self)
    }
    
    @IBAction func runButtonPressed(_ sender: Any) {
        workoutData.activityType = .run
        performSegue(withIdentifier: "ActivityPageViewController", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

