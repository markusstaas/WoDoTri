//
//  ActivityViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/10/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import CoreLocation

class ActivityViewController: UIViewController {
    
    var activity: Activity!
    var activityState: String! = "Stopped"
    let locationManager = LocationManager.shared
    var distance = Measurement(value: 0, unit: UnitLength.meters)

    var locationList: [CLLocation] = []
    let stopwatch = StopWatch()
    var activityType = "Running"
    @IBOutlet weak var startButt: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    
    
    func tick() {
        elapsedTimeLabel.text = stopwatch.elapsedTimeAsString()
        updateDisplay()
    }
    
    @IBAction func startButtonPressed(_ sender: Any){
        if activityState == "Stopped"{
            startActivity()
        } else if activityState == "Paused"{
            restartActivity()
        } else if activityState == "Started"{
            pauseActivity()
        }
    }
    @IBAction func stopButtonPressed(_ sender: Any) {
       stopActivity()
    }
    

    private func startActivity(){
        stopwatch.start()
        activityState = "Started"
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        startLocationUpdates()
        startButt.backgroundColor = UIColor.orange
        startButt.setTitle("Pause", for: .normal)
        tick()
        stopwatch.callback = self.tick
    }
    
    private func restartActivity(){
        activityState = "Started"
        stopwatch.start()
        updateDisplay()
        locationManager.startUpdatingLocation()
        startButt.backgroundColor = UIColor.orange
        startButt.setTitle("Pause", for: .normal)
    }
    
    private func stopActivity(){
        activityState = "Stopped"
        stopwatch.stop()
        locationManager.stopUpdatingLocation()
        performSegue(withIdentifier: "FinishView", sender: self)
       
    }
    
    private func pauseActivity(){
        stopwatch.stop()
        activityState = "Paused"
        locationManager.stopUpdatingLocation()
        startButt.backgroundColor = UIColor.green
        startButt.setTitle("Continue", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: Int(stopwatch.elapsedTime), outputUnit: UnitSpeed.minutesPerMile)
        distanceLabel.text = formattedDistance
        paceLabel.text = formattedPace
    }

    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FinishView") {
            let viewController = segue.destination as! FinishViewController
            viewController.finalDistance = distance.value
            viewController.finalDuration = Int16(stopwatch.elapsedTime)
            viewController.activityDuration = stopwatch.elapsedTimeAsString()
            viewController.finalTimestamp = Date()
            viewController.locationList = locationList
        }
    }
    
    
    


}
