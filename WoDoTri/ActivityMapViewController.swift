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
    
    @IBOutlet weak var startButt: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    func tick() {
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
    }
}

extension ActivityMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
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
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }
            workoutData.locationList.append(newLocation)
        }
    }
}
