//
//  WorkoutStates.swift
//  WoDoTri
//
//  Created by Markus Staas on 12/3/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import Foundation

enum WorkoutState {
    case notStarted
    case started
    case paused
    case restarted
    case stopped
}

enum ActivityType {
   // case swim
    case bike
    case run
    var description: String {
        switch self {
       // case .swim: return "Swim";
        case .bike: return "Ride"
        case .run: return "Run"
        }
    }
}
