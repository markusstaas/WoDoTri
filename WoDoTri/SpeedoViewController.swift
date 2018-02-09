//
//  SpeedoViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/18/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SpeedoViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager = CLLocationManager()
    var switchSpeed = "KPH"
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance: Double = 0
    var arrayMPH: [Double]! = []
    var arrayKPH: [Double]! = []

    @IBOutlet weak var speedDisplay: UILabel!
    @IBOutlet weak var headingDisplay: UILabel!
    @IBOutlet weak var distanceTraveled: UILabel!
    @IBOutlet weak var minSpeedLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        minSpeedLabel.text = "0"
        maxSpeedLabel.text = "0"

        self.locationManager.requestAlwaysAuthorization()

        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    // 1 mile = 5280 feet
    // Meter to miles = m * 0.00062137
    // 1 meter = 3.28084 feet
    // 1 foot = 0.3048 meters
    // km = m / 1000
    // m = km * 1000
    // ft = m / 3.28084
    // 1 mile = 1609 meters
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
            if lastLocation != nil {
            traveledDistance += lastLocation.distance(from: locations.last!)
            if switchSpeed == "MPH" {
                if traveledDistance < 1609 {
                    let tdF = traveledDistance / 3.28084
                    distanceTraveled.text = (String(format: "%.1f Feet", tdF))
                } else if traveledDistance > 1609 {
                    let tdM = traveledDistance * 0.00062137
                    distanceTraveled.text = (String(format: "%.1f Miles", tdM))
                }
            }
            if switchSpeed == "KPH" {
                if traveledDistance < 1609 {
                    let tdMeter = traveledDistance
                    distanceTraveled.text = (String(format: "%.0f Meters", tdMeter))
                } else if traveledDistance > 1609 {
                    let tdKm = traveledDistance / 1000
                    distanceTraveled.text = (String(format: "%.1f Km", tdKm))
                }
            }
        }
        lastLocation = locations.last

    }
    func updateLocationInfo(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        speed: CLLocationSpeed,
        direction: CLLocationDirection) {
        let speedToMPH = (speed * 2.23694)
        let speedToKPH = (speed * 3.6)
        let val = ((direction / 22.5) + 0.5)
        var arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
       // let dir = arr[Int(val % 16)]
        //lonDisplay.text = coordinateString(latitude, longitude: longitude)
       // lonDisplay.text = (String(format: "%.3f", longitude))
        //latDisplay.text = (String(format: "%.3f", latitude))
        if switchSpeed == "MPH" {
            // Chekcing if speed is less than zero or a negitave number to display a zero
            if speedToMPH > 0 {
                speedDisplay.text = (String(format: "%.0f mph", speedToMPH))
                arrayMPH.append(speedToMPH)
                let lowSpeed = arrayMPH.min()
                let highSpeed = arrayMPH.max()
                minSpeedLabel.text = (String(format: "%.0f mph", lowSpeed!))
                maxSpeedLabel.text = (String(format: "%.0f mph", highSpeed!))
                avgSpeed()
                //                print("Low: \(lowSpeed!) - High: \(highSpeed!)")
            } else {
                speedDisplay.text = "0 mph"
            }
        }
        if switchSpeed == "KPH" {
            // Checking if speed is less than zero
            if speedToKPH > 0 {
                speedDisplay.text = (String(format: "%.0f km/h", speedToKPH))
                arrayKPH.append(speedToKPH)
                let lowSpeed = arrayKPH.min()
                let highSpeed = arrayKPH.max()
                minSpeedLabel.text = (String(format: "%.0f km/h", lowSpeed!))
                maxSpeedLabel.text = (String(format: "%.0f km/h", highSpeed!))
                avgSpeed()
                //  print("Low: \(lowSpeed!) - High: \(highSpeed!)")
            } else {
                speedDisplay.text = "0 km/h"
            }
        }
        // Shows the N - E - S W
      //  headingDisplay.text = "\(dir)"

    }
    func avgSpeed() {
        if switchSpeed == "MPH" {
            let votes: [Double] = arrayMPH
            let votesAvg = votes.reduce(0, +) / Double(votes.count)
            avgSpeedLabel.text = (String(format: "%.0f", votesAvg))
            //print( votesAvg )
        } else if switchSpeed == "KPH" {
            let votes: [Double] = arrayKPH
            let votesAvg = votes.reduce(0, +) / Double(votes.count)
            avgSpeedLabel.text = (String(format: "%.0f", votesAvg))
            //print( votesAvg
        }
    }
    @IBAction func speedSwitch(_ sender: Any) {
    }
    @IBAction func restTripButton(_ sender: Any) {
    }
    @IBAction func startTrip(_ sender: Any) {
    }

}
