//  Copyright © 2018 Markus Staas. All rights reserved.

import CoreData

final class Workout: NSManagedObject {

    private static let entityName = String(describing: self)

    @NSManaged private var type: String
    @NSManaged private var isPaused: Bool
    @NSManaged private var distance: Double
    @NSManaged private var duration: Double
    @NSManaged private var lastUpdatedAt: Date
    @NSManaged private var locations: Set<Location>

    // add location -> update lastUpdatedAt, add location to the list
    // start / pause


    // TODO: Make addDistance and co private?
    // TODO: Figure out addLocation/locations vs what happensaddDistance
    // when the user is on a threadmill for example (i.e. how to update duration?)
    // consider using the Delegate pattern, maybe



//    let workoutType: WorkoutType
//
//    private var locationsForCurrentLap: Set<CLLocation> = []
//    private var locationsForPreviousLaps: Set<CLLocation> = []
//
//    private var startDate: Date?
//    private var previousDuration = Measurement(value: 0, unit: UnitDuration.seconds)
//
//    private(set) var distance = Workout.initialDistance
//    private(set) var distanceText = Workout.makeDistanceText(for: Workout.initialDistance)
//
//    private static let initialDistance = Measurement(value: 0, unit: UnitLength.meters)
//
//    // MARK: - Creating Workout
//
//    init(workoutType: WorkoutType) {
//        self.workoutType = workoutType
//    }
//
    // MARK: - Starting and Pausing Workout

    func setWorkoutPaused(_ paused: Bool) {
        precondition(isPaused != paused)
        isPaused = paused
        lastUpdatedAt = Date()
    }

//    // MARK: - Managing Locations
//
//    mutating func addLocation(_ location: CLLocation) {
//        let sortedLocationsForCurrentLap = locationsForCurrentLap.sorted { location, otherLocation in
//            location.timestamp > otherLocation.timestamp
//        }
//        if let lastLocation = sortedLocationsForCurrentLap.last, startDate != nil {
//            let delta = location.distance(from: lastLocation)
//            let deltaMeasurement = Measurement(value: delta, unit: UnitLength.meters)
//            addDistance(deltaMeasurement)
//        }
//        locationsForCurrentLap.insert(location)
//    }
//
//    var locations: Set<CLLocation> {
//        return locationsForCurrentLap.union(locationsForPreviousLaps)
//    }
//
//    // MARK: - Managing Duration
//
//    var duration: Measurement<UnitDuration> {
//        guard let startDate = startDate else { return previousDuration }
//        let currentDurationInSeconds = Date().timeIntervalSince(startDate)
//        let currentDuration = Measurement(value: currentDurationInSeconds, unit: UnitDuration.seconds)
//        return previousDuration + currentDuration
//    }
//
//    var durationText: String {
//        return Workout.makeDurationText(for: duration)
//    }
//
//    static func makeDurationText(for duration: Measurement<UnitDuration>) -> String {
//        let seconds = duration.converted(to: UnitDuration.seconds).value
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.zeroFormattingBehavior = .pad
//        return formatter.string(from: seconds)!
//    }
//
//    // MARK: - Managing Distance
//
//    mutating func addDistance(_ newDistance: Measurement<UnitLength>) {
//        setDistance(distance + newDistance)
//    }
//
//    mutating func resetDistance() {
//        setDistance(Workout.initialDistance)
//    }
//
//    private mutating func setDistance(_ newDistance: Measurement<UnitLength>) {
//        distance = newDistance
//        distanceText = Workout.makeDistanceText(for: newDistance)
//    }
//
//    static func makeDistanceText(for distance: Measurement<UnitLength>) -> String {
//        let formatter = MeasurementFormatter()
//        formatter.numberFormatter.minimumFractionDigits = 2
//        formatter.numberFormatter.maximumFractionDigits = 2
//        return formatter.string(from: distance)
//    }





    @objc(addLocationsObject:)
    @NSManaged private func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged private func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged private func addToLocations(_ values: Set<Location>)

    @objc(removeLocations:)
    @NSManaged private func removeFromLocations(_ values: Set<Location>)

    static func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: entityName)
    }

}
