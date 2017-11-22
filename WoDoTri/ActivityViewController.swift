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
    var activityActive: Bool! = false
    
    let locationManager = LocationManager.shared
    //var seconds = 0

    var distance = Measurement(value: 0, unit: UnitLength.meters)

    var locationList: [CLLocation] = []
    let stopwatch = StopWatch()
    var activityType = "Running"
    @IBOutlet weak var startButt: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    func tick() {
        elapsedTimeLabel.text = stopwatch.elapsedTimeAsString()
        updateDisplay()
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        !activityActive ? startActivity() : pauseActivity()
        
    }
    @IBAction func stopButtonPressed(_ sender: Any) {
       stopActivity()
    }
    
    private func startActivity(){
        stopwatch.start()
        activityActive = true
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        startLocationUpdates()
        startButt.backgroundColor = UIColor.orange
        startButt.setTitle("Pause", for: .normal)
    }
    private func restartActivity(){
        stopwatch.start()
        updateDisplay()
        startLocationUpdates()
        startButt.backgroundColor = UIColor.green
        startButt.setTitle("Pause", for: .normal)
    }
    
    private func stopActivity(){
        stopwatch.stop()
        performSegue(withIdentifier: "FinishView", sender: self)
    }
    
    private func pauseActivity(){
        stopwatch.stop()
        startButt.backgroundColor = UIColor.green
        startButt.setTitle("Continue", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tick()
        stopwatch.callback = self.tick

        locationManager.stopUpdatingLocation()
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
       // let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: Int(stopwatch.elapsedTime), outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = formattedDistance
       //timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = formattedPace
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FinishView") {
            let viewController = segue.destination as! FinishViewController
            viewController.elapsedTime = stopwatch.elapsedTimeAsString()
        }
    }
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }

}
