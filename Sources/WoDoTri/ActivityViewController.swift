////  Copyright © 2017 Markus Staas. All rights reserved.
//
//import UIKit
//import CoreLocation
//
//final class ActivityViewController: UIViewController, CLLocationManagerDelegate {
//
//    private var activity: Activity!
//    private let workout = Workout.shared
//    private let locationManager = LocationManager.shared
//    private let stopwatch = StopWatch()
//
//    @IBOutlet private weak var pauseButt: UIButton!
//    @IBOutlet private weak var startButt: UIButton!
//    @IBOutlet private weak var elapsedTimeLabel: UILabel!
//    @IBOutlet private weak var paceLabel: UILabel!
//    @IBOutlet private weak var distanceLabel: UILabel!
//    @IBOutlet private weak var averagePaceLabel: UILabel!
//
//    private func tick() {
//        updateDisplay()
//        workout.durationString = stopwatch.elapsedTimeAsString()
//        workout.duration = stopwatch.elapsedTime
//        elapsedTimeLabel.text = workout.durationString
//    }
//
//    private func startActivity() {
//        stopwatch.start()
//        workout.activityState = .started
//        workout.resetDistance()
//        workout.locationList.removeAll()
//        startLocationUpdates()
//        tick()
//        stopwatch.callback = self.tick
//        startButt.isHidden = true
//        pauseButt.isHidden = false
//    }
//
//    private func restartActivity() {
//        workout.activityState = .restarted
//        stopwatch.start()
//        stopwatch.elapsedTime = workout.duration
//        tick()
//        startLocationUpdates()
//        stopwatch.callback = self.tick
//        startButt.isHidden = true
//        pauseButt.isHidden = false
//    }
//
//    private func pauseActivity() {
//        stopwatch.pause()
//        workout.activityState = .paused
//        locationManager.stopUpdatingLocation()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        if workout.activityState == .started || workout.activityState == .restarted {
//            restartActivity()
//        }
//        if workout.activityState == .stopped || workout.activityState == .notStarted {
//            pauseButt.isHidden = true
//        }
//    }
//
//    private func assignBackground() {
//        let background = UIImage(named: "backgroundrunner")
//        var imageView: UIImageView!
//        imageView = UIImageView(frame: view.frame)
//        imageView.contentMode =  UIViewContentMode.center
//        imageView.clipsToBounds = true
//        imageView.image = background
//        imageView.center = view.center
//        view.addSubview(imageView)
//        self.view.sendSubview(toBack: imageView)
//    }
//
//    @IBAction private func startButtonPressed(_ sender: Any) {
//       startActivity()
//    }
//
//    @IBAction private func pauseButtonPressed(_ sender: Any) {
//        pauseActivity()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        assignBackground()
//    }
//
//    private func updateDisplay() {
//        let locale = NSLocale.current
//        let isMetric = locale.usesMetricSystem
//        if !isMetric {
//            let formattedPace = FormatDisplay.pace(
//                distance: workout.distance,
//                seconds: Int(stopwatch.elapsedTime),
//                outputUnit: UnitSpeed.minutesPerMile)
//            paceLabel.text = formattedPace
//        } else {
//            let formattedPace = FormatDisplay.pace(
//                distance: workout.distance,
//                seconds: Int(stopwatch.elapsedTime),
//                outputUnit: UnitSpeed.minutesPerKilometer)
//            paceLabel.text = formattedPace
//        }
//        distanceLabel.text = workout.distanceText
//    }
//
//    private func startLocationUpdates() {
//        locationManager.delegate = self
//        locationManager.activityType = .fitness
//        locationManager.distanceFilter = 10
//        locationManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        for newLocation in locations {
//            let howRecent = newLocation.timestamp.timeIntervalSinceNow
//            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
//            if let lastLocation = workout.locationList.last {
//                if workout.activityState == .started {
//                    let delta = newLocation.distance(from: lastLocation)
//                    let deltaMeasurement = Measurement(value: delta, unit: UnitLength.meters)
//                    workout.addDistance(deltaMeasurement)
//                }
//                if workout.activityState == .restarted {
//                    // out of pause state, Delta to 0 because
//                    //we dont want to use the distance traveled during pause state
//                    workout.activityState = .started
//                }
//            }
//            workout.locationList.append(newLocation)
//        }
//    }
//
//}

