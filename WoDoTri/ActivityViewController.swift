//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit
import CoreLocation

final class ActivityViewController: UIViewController, CLLocationManagerDelegate {

    private var activity: Activity!
    private let workoutData = Workout.shared
    private let locationManager = LocationManager.shared
    private let stopwatch = StopWatch()

    @IBOutlet private weak var pauseButt: UIButton!
    @IBOutlet private weak var startButt: UIButton!
    @IBOutlet private weak var elapsedTimeLabel: UILabel!
    @IBOutlet private weak var paceLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var averagePaceLabel: UILabel!

    private func tick() {
        updateDisplay()
        workoutData.durationString = stopwatch.elapsedTimeAsString()
        workoutData.duration = stopwatch.elapsedTime
        elapsedTimeLabel.text = workoutData.durationString
    }

    private func startActivity() {
        stopwatch.start()
        workoutData.activityState = .started
        workoutData.resetDistance()
        workoutData.locationList.removeAll()
        startLocationUpdates()
        tick()
        stopwatch.callback = self.tick
        startButt.isHidden = true
        pauseButt.isHidden = false
    }

    private func restartActivity() {
        workoutData.activityState = .restarted
        stopwatch.start()
        stopwatch.elapsedTime = workoutData.duration
        tick()
        startLocationUpdates()
        stopwatch.callback = self.tick
        startButt.isHidden = true
        pauseButt.isHidden = false
    }

    private func pauseActivity() {
        stopwatch.pause()
        workoutData.activityState = .paused
        locationManager.stopUpdatingLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        if workoutData.activityState == .started || workoutData.activityState == .restarted {
            restartActivity()
        }
        if workoutData.activityState == .stopped || workoutData.activityState == .notStarted {
            pauseButt.isHidden = true
        }
    }

    private func assignBackground() {
        let background = UIImage(named: "backgroundrunner")
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.frame)
        imageView.contentMode =  UIViewContentMode.center
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }

    @IBAction private func startButtonPressed(_ sender: Any) {
       startActivity()
    }

    @IBAction private func pauseButtonPressed(_ sender: Any) {
        pauseActivity()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
    }

    private func updateDisplay() {
        let locale = NSLocale.current
        let isMetric = locale.usesMetricSystem
        if !isMetric {
            let formattedPace = FormatDisplay.pace(
                distance: workoutData.distance,
                seconds: Int(stopwatch.elapsedTime),
                outputUnit: UnitSpeed.minutesPerMile)
            paceLabel.text = formattedPace
        } else {
            let formattedPace = FormatDisplay.pace(
                distance: workoutData.distance,
                seconds: Int(stopwatch.elapsedTime),
                outputUnit: UnitSpeed.minutesPerKilometer)
            paceLabel.text = formattedPace
        }
        distanceLabel.text = workoutData.distanceText
    }

    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            if let lastLocation = workoutData.locationList.last {
                if workoutData.activityState == .started {
                    let delta = newLocation.distance(from: lastLocation)
                    let deltaMeasurement = Measurement(value: delta, unit: UnitLength.meters)
                    workoutData.addDistance(deltaMeasurement)
                }
                if workoutData.activityState == .restarted {
                    // out of pause state, Delta to 0 because
                    //we dont want to use the distance traveled during pause state
                    workoutData.activityState = .started
                }
            }
            workoutData.locationList.append(newLocation)
        }
    }

}
