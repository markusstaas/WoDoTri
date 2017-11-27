//
//  FinishViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/12/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class FinishViewController: UIViewController {
    var activity: Activity!
    
    let stopwatch = StopWatch()
    var locationList: [CLLocation] = []
    var finalDistance = 0.000
    var finalDuration: Int16!
    var activityDuration: String?
    var finalTimestamp: Date?

    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var completedDistanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elapsedTimeLabel.text = activityDuration
    }

    @IBAction func finishButtonPressed(_ sender: Any) {
        saveActivity()
    }

    @IBAction func discardButtonPressed(_ sender: Any) {
        stopwatch.reset()
    }
    
    //////Core Data
    private func saveActivity() {
        let newActivity = Activity(context: CoreDataStack.context)
        newActivity.distance = finalDistance
        newActivity.duration = finalDuration
        newActivity.timestamp = Date()

        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newActivity.addToLocations(locationObject)
        }
        CoreDataStack.saveContext()
        activity = newActivity
    }
   

}
