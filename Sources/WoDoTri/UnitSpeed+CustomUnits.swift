//  Copyright © 2018 Markus Staas. All rights reserved.

import Foundation

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

}
