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
    let locationManager = LocationManager.shared
    let workoutData = WorkoutData.shared
    let stopwatch = StopWatch()
    
    
    @IBOutlet weak var startButt: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    
    func tick() {
        elapsedTimeLabel.text = stopwatch.elapsedTimeAsString()
        workoutData.duration = stopwatch.elapsedTime
        updateDisplay()
    }
    
    @IBAction func startButtonPressed(_ sender: Any){
        switch workoutData.activityState{
            case .notStarted: startActivity()
            case .stopped: startActivity()
            case .paused: restartActivity()
            case .started: pauseActivity()
            case .restarted: pauseActivity()
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopActivity()
    }
 
    private func startActivity(){
        stopwatch.start()
        workoutData.activityState = .started
        workoutData.distance = Measurement(value: 0, unit: UnitLength.meters)
        workoutData.locationList.removeAll()
        startLocationUpdates()
        startButt.backgroundColor = UIColor.orange
        startButt.setTitle("Pause", for: .normal)
        tick()
        stopwatch.callback = self.tick
    }
    
    private func restartActivity(){
        workoutData.activityState = .restarted
        stopwatch.start()
        tick()
        startLocationUpdates()
        startButt.backgroundColor = UIColor.orange
        startButt.setTitle("Pause", for: .normal)
    }
    
    private func pauseActivity(){
        stopwatch.paused()
        workoutData.activityState = .paused
        locationManager.stopUpdatingLocation()
        startButt.backgroundColor = UIColor.green
        startButt.setTitle("Continue", for: .normal)
    }
    
    private func stopActivity(){
        workoutData.activityState = .stopped
        stopwatch.stop()
        locationManager.stopUpdatingLocation()
        performSegue(withIdentifier: "FinishView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     func updateDisplay() {
        let locale = NSLocale.current
        let isMetric = locale.usesMetricSystem
        if !isMetric{
            let formattedPace = FormatDisplay.pace(distance: workoutData.distance, seconds: Int(stopwatch.elapsedTime), outputUnit: UnitSpeed.minutesPerMile)
            paceLabel.text = formattedPace
        } else{
            let formattedPace = FormatDisplay.pace(distance: workoutData.distance, seconds: Int(stopwatch.elapsedTime), outputUnit: UnitSpeed.minutesPerKilometer)
            paceLabel.text = formattedPace
        }
        let formattedDistance = FormatDisplay.distance(workoutData.distance)
        distanceLabel.text = formattedDistance
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
            viewController.activityDuration = stopwatch.elapsedTimeAsString()
            viewController.finalTimestamp = Date()
        }
    }
}
