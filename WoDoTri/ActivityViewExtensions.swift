//
//  ActivityViewExtensions.swift
//  WoDoTri
//
//  Created by Markus Staas (Lazada eLogistics Group) on 11/22/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import CoreLocation

extension ActivityViewController: CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            if let lastLocation = locationList.last {
                if activityState == .started{
                    let delta = newLocation.distance(from: lastLocation)
                    distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                }
                if activityState == .restarted{
                    //getting out of pause state, setting Delta to 0.0 because we dont want to use the distance traveled during pause state
                    distance = distance + Measurement(value: 0.0, unit: UnitLength.meters)
                    activityState = .started
                }
            }
            locationList.append(newLocation)
        }
    }

}
