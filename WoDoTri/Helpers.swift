//
//  Helpers.swift
//  WoDoTri
//
//  Created by Markus Staas (Lazada eLogistics Group) on 11/27/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation

struct Helpers {
    
    static func avgPace(distance: Measurement<UnitLength>, seconds: Int, outputUnit: UnitSpeed) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = [.providedUnit] // 1
        formatter.numberFormatter.minimumFractionDigits = 1
        formatter.numberFormatter.maximumFractionDigits = 1
        let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
        // distance.value
        let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.metersPerSecond)
        return formatter.string(from: speed.converted(to: outputUnit))
    }
        
    
    
    
}
