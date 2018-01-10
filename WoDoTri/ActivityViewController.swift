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
    func assignBackground(){
        let background = UIImage(named: "backgroundrunner")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.frame)
        imageView.contentMode =  UIViewContentMode.center
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    @IBAction func startButtonPressed(_ sender: Any){
       startActivity()
        startButt.isHidden = true
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        pauseActivity()
        
    }
 
    private func startActivity(){
        stopwatch.start()
        workoutData.activityState = .started
        workoutData.distance = Measurement(value: 0, unit: UnitLength.meters)
        workoutData.locationList.removeAll()
        startLocationUpdates()
        tick()
        stopwatch.callback = self.tick
    }
    
    private func restartActivity(){
        workoutData.activityState = .restarted
        stopwatch.start()
        tick()
        startLocationUpdates()
    }
    
    private func pauseActivity(){
        stopwatch.paused()
        workoutData.activityState = .paused
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
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
