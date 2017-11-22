//
//  UnitCalculations.swift
//  WoDoTri
//
//  Created by Markus Staas (Lazada eLogistics Group) on 11/22/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
// Based on https://www.raywenderlich.com/155772/make-app-like-runkeeper-part-1-2

import Foundation

class UnitConverterPace: UnitConverter {
    private let coefficient: Double
    
    init(coefficient: Double) {
        self.coefficient = coefficient
    }
    
    override func baseUnitValue(fromValue value: Double) -> Double {
        return reciprocal(value * coefficient)
    }
    
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        return reciprocal(baseUnitValue * coefficient)
    }
    
    private func reciprocal(_ value: Double) -> Double {
        guard value != 0 else { return 0 }
        return 1.0 / value
    }
}

extension UnitSpeed {
    class var secondsPerMeter: UnitSpeed {
        return UnitSpeed(symbol: "sec/m", converter: UnitConverterPace(coefficient: 1))
    }
    
    class var minutesPerKilometer: UnitSpeed {
        return UnitSpeed(symbol: "min/km", converter: UnitConverterPace(coefficient: 60.0 / 1000.0))
    }
    
    class var minutesPerMile: UnitSpeed {
        return UnitSpeed(symbol: "min/mi", converter: UnitConverterPace(coefficient: 60.0 / 1609.34))
    }
    class var kmPerHour: UnitSpeed{
        return UnitSpeed(symbol: "km/h", converter: UnitConverterPace(coefficient: 0.277778 ))
    }
}
