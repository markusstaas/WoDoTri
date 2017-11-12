//
//  SpeedoMat.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/12/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation
import CoreLocation


class SpeedoMat{

    public var test = "test"
    
    var locationManager: CLLocationManager = CLLocationManager()
   // var switchSpeed = "KPH"
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    var arrayMPH: [Double]! = []
    var arrayKPH: [Double]! = []
    
    
    
    
}
