//
//  WorkoutData.swift
//  WoDoTri
//
//  Created by Markus Staas on 12/6/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import CoreLocation

class WorkoutData{
    
    static let shared = WorkoutData()
    var stopwatch = StopWatch()
    var activityType = ActivityType.run
    var activityState = WorkoutState.notStarted
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var distanceFormatted: String
    var avgPace: String
    var locationList: [CLLocation] = []
    var duration = 0.00
    
    init() {
        self.distanceFormatted = ""
        self.avgPace = ""
    }
    func distanceString() -> String{
        self.distanceFormatted = FormatDisplay.distance(distance)
        return distanceFormatted
    }
    func avgPaceString() -> String{
        self.avgPace = FormatDisplay.avgPace(distance: distance, seconds: Int(duration), outputUnit: UnitSpeed.minutesPerMile)
        return avgPace
    }
  
    
    
}
