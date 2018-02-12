//  Copyright © 2017 Markus Staas. All rights reserved.

import Foundation

enum WorkoutState {

    case notStarted
    case started
    case paused
    case restarted
    case stopped

}

enum ActivityType {

    case bike
    case run
    var description: String {
        switch self {
        case .bike: return "Ride"
        case .run: return "Run"
        }
    }

}
