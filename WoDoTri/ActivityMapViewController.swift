//
//  ActivityMapViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/10/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ActivityMapViewController: UIViewController{
    
    var activity: Activity!
    let workoutData = WorkoutData.shared
    let locationManager = LocationManager.shared
    let stopwatch = StopWatch()
    
    @IBOutlet weak var pauseButt: UIButton!
    @IBOutlet weak var startButt: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var mapContainerView: UIView!
    
    func addReusableViewController() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: MapChildViewController.self)) as? MapChildViewController else { return }
        vc.willMove(toParentViewController: self)
        addChildViewController(vc)
        mapContainerView.addSubview(vc.view)
        constraintViewEqual(view1: mapContainerView, view2: vc.view)
        vc.didMove(toParentViewController: self)
    }
    /// Sticks child view (view1) to the parent view (view2) using constraints.
    private func constraintViewEqual(view1: UIView, view2: UIView) {
        view2.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view2, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
        let constraint2 = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view2, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
        let constraint3 = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view2, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
        let constraint4 = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view2, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
        view1.addConstraints([constraint1, constraint2, constraint3, constraint4])
    }
    
    func tick() {
        updateDisplay()
        workoutData.durationString = stopwatch.elapsedTimeAsString()
        workoutData.duration = stopwatch.elapsedTime
    }
    
    @IBAction func startButtonPressed(_ sender: Any){
        startActivity()
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
        startButt.isHidden = true
        pauseButt.isHidden = false
    }
    
    private func restartActivity(){
        workoutData.activityState = .restarted
        stopwatch.start()
        stopwatch.elapsedTime = workoutData.duration
        tick()
        startLocationUpdates()
        stopwatch.callback = self.tick
        startButt.isHidden = true
        pauseButt.isHidden = false
    }
    
    private func pauseActivity(){
        stopwatch.paused()
        workoutData.activityState = .paused
        locationManager.stopUpdatingLocation()
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
    
    func updateDisplay() {
        let locale = NSLocale.current
        let isMetric = locale.usesMetricSystem
        if !isMetric{
         //   let formattedPace = FormatDisplay.pace(distance: distance, seconds: Int(stopwatch.elapsedTime), outputUnit: UnitSpeed.minutesPerMile)
            //paceLabel.text = formattedPace
        } else{
         //   let formattedPace = FormatDisplay.pace(distance: distance, seconds: Int(stopwatch.elapsedTime), outputUnit: UnitSpeed.minutesPerKilometer)
           // paceLabel.text = formattedPace
        }
      //  let formattedDistance = FormatDisplay.distance(distance)
       // distanceLabel.text = formattedDistance
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addReusableViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // replace with swtich
        if workoutData.activityState == .started || workoutData.activityState == .restarted{
            restartActivity()
        }
        if workoutData.activityState == .stopped || workoutData.activityState == .notStarted {
            pauseButt.isHidden = true
        }
        
    }
 
}



extension ActivityMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = workoutData.locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                workoutData.distance = workoutData.distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                //mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
               // mapView.setRegion(region, animated: true)
            }
            workoutData.locationList.append(newLocation)
        }
    }
}
