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
    var subContext = CoreDataStack.context
    var activityType = ActivityType.run
    let stopwatch = StopWatch()
    var locationList: [CLLocation] = []
    var finalDistance = 0.000
    var finalDistanceFormatted: String!
    var finalDuration: Int16!
    var avgPace: String!
    var activityDuration: String?
    var finalTimestamp: Date?

    
    @IBOutlet weak var activityTypeLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var avgPaceLabel: UILabel!
    @IBOutlet weak var completedDistanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityTypeLabel.text = activityType.description
        elapsedTimeLabel.text = "Duration: \(activityDuration!)"
        completedDistanceLabel.text = "Distance: \(finalDistanceFormatted!)"
        avgPaceLabel.text = "Average speed: \(avgPace!)"
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: subContext)
    }

    @IBAction func finishButtonPressed(_ sender: Any) {
        saveActivity()
    }

    @IBAction func discardButtonPressed(_ sender: Any) {
        stopwatch.reset()
    }
    
    @objc func managedObjectContextDidSave(notification: NSNotification) {
        if notification.name == NSNotification.Name.NSManagedObjectContextDidSave {
            let alert = UIAlertController(title: "Workout Saved", message: "Your workout has been saved. Tap OK to return to the start screen", preferredStyle: .actionSheet)
            let savedAction = UIAlertAction(title: "OK", style: .default) { [unowned self] action in
                self.performSegue(withIdentifier: "homeSegue", sender: self)
                self.navigationController?.popViewController(animated: false)
            }
            alert.addAction(savedAction)
            present(alert, animated: true)

        }
    }
    //////Core Data
    private func saveActivity() {
        let newActivity = Activity(context: CoreDataStack.context)
        newActivity.distance = finalDistance
        newActivity.duration = finalDuration
        newActivity.type = activityType.description
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
