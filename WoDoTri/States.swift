//
//  States.swift
//  WoDoTri
//
//  Created by Markus Staas (Lazada eLogistics Group) on 12/3/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation

enum WorkoutState{
    case notStarted
    case started
    case paused
    case restarted
    case stopped
}

enum ActivityType{
    case swim
    case bike
    case run
    
    var description : String {
        switch self {
        case .swim: return "Swim";
        case .bike: return "Bike Ride";
        case .run: return "Run";
        }
    }
}
