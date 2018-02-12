//  Copyright © 2017 Markus Staas. All rights reserved.

enum WorkoutType {

    case bike
    case run

    var description: String {
        switch self {
        case .bike: return "Ride"
        case .run: return "Run"
        }
    }

}
