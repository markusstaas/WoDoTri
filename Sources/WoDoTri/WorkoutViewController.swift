import UIKit
import CoreData
import CoreLocation

protocol WorkoutViewControllerDataSource: AnyObject {

    func workoutType(for workoutViewController: WorkoutViewController) -> WorkoutType
}

final class WorkoutViewController: UIViewController, StartWorkoutButtonDelegate {

    weak var dataSource: WorkoutViewControllerDataSource!

    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    private var workout: Workout!
    private let locationManager = CLLocationManager()
    private var updateTimer: Timer!
    private let updateInterval: TimeInterval = 0.1
    private let locationDistanceFilter: CLLocationDistance = 20
    private var instantVelocity: Double!
    private var currentLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    private var workoutDataViewController: WorkoutDataViewController?
    private var workoutMapViewController: WorkoutMapViewController?
    private var workoutPausedViewController: WorkoutPausedViewController?
    private let workoutPausedViewControllerSegueIdentifier = "Workout Paused View Controller Segue"

    @IBOutlet private var primaryActionButton: UIButton!
    @IBOutlet private var pageControl: UIPageControl!

    // MARK: - Handling View Lifecycle

    override func viewDidLoad() {
        super .viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        //appDelegate?.persistentContainer.loadPersistentStores { _, _ in }
        let workoutType = dataSource.workoutType(for: self)
        workout = Workout(workoutType: workoutType, managedObjectContext: (appDelegate?.persistentContainer.viewContext)!)
        setPrimaryActionButtonLabel()

    }

    // MARK: - Handling Storyboard Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationWorkoutDataViewController = segue.destination as? WorkoutDataViewController {
            destinationWorkoutDataViewController.dataSource = self
            workoutDataViewController = destinationWorkoutDataViewController
        }
        if let destinationWorkoutMapViewController = segue.destination as? WorkoutMapViewController {
            destinationWorkoutMapViewController.dataSource = self
            workoutMapViewController = destinationWorkoutMapViewController
        }
        if let destinationWorkoutPausedViewController = segue.destination as? WorkoutPausedViewController {
            workoutPausedViewController = destinationWorkoutPausedViewController
            destinationWorkoutPausedViewController.delegate = self
            destinationWorkoutPausedViewController.dataSource = self
        }
    }

    // MARK: - Managing Timer

    private func createTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.workout.updateDuration()
            self?.workoutDataViewController?.updateView()
        }
    }

    // MARK: - Managing Start and Pause 

    @IBAction func startOrPauseWorkout() {
        if workout.isPaused {
            startWorkout()
        } else {
            pauseWorkout()
        }
    }

    private func pauseWorkout() {
        workout.isPaused = true
        workout.updateDuration()
        setPrimaryActionButtonLabel()
        performSegue(withIdentifier: workoutPausedViewControllerSegueIdentifier, sender: self)
    }

    private func startWorkout() {
        locationManager.startUpdatingLocation()
        locationManager.activityType = .fitness
        locationManager.distanceFilter = locationDistanceFilter
        locationManager.showsBackgroundLocationIndicator = true
        workout.isPaused = false
        createTimer()
        setPrimaryActionButtonLabel()
    }

    private func setPrimaryActionButtonLabel() {
        if !workout.isPaused {
            primaryActionButton.setTitle("Pause", for: UIControl.State.normal)
        } else {
            primaryActionButton.setTitle("Start", for: UIControl.State.normal)
        }

    }

}

// MARK: - Managing UIScrollView

extension WorkoutViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        precondition(pageControl.numberOfPages == 2)
        let horizontalScrollOffset = scrollView.contentOffset.x
        let horizontalMiddleOffset = scrollView.frame.width / 2
        let isPastMiddle = horizontalScrollOffset < horizontalMiddleOffset
        pageControl.currentPage = isPastMiddle ? 0 : 1
    }

}

// MARK: - Managing WorkoutDataViewController

extension WorkoutViewController: WorkoutDataViewControllerDataSource {

    func workoutType(for workoutDataViewController: WorkoutDataViewController) -> WorkoutType {
        return workout.workoutType
    }

    func workoutDistance(for workoutDataViewController: WorkoutDataViewController) -> Double {
        return workout.distance
    }

    func workoutDuration(for workoutDataViewController: WorkoutDataViewController) -> Double {
        return workout.duration
    }
    func workoutInstantVelocity(for workoutDataViewController: WorkoutDataViewController) -> Double {
        if let instantVelocity = instantVelocity {
        return instantVelocity
        } else {
            return 0
        }
    }

}

// MARK: - Managing WorkoutMapViewController

extension WorkoutViewController: WorkoutMapViewControllerDataSource {

    func locationHistory(for workoutMapViewController: WorkoutMapViewController) -> Set<WorkoutLocation> {
        return workout.locationHistory
    }

    func currenLocation(for workoutMapViewController: WorkoutMapViewController) -> WorkoutLocation {
        return (workout?.currentLocation)!
    }

}

// MARK: - Managing WorkoutPausedViewController

extension WorkoutViewController: WorkoutPausedViewControllerDataSource {

    func workoutType(for workoutPausedViewController: WorkoutPausedViewController) -> WorkoutType {
        return workout.workoutType
    }

    func workoutDistance(for workoutPausedViewController: WorkoutPausedViewController) -> Double {
        return workout.distance
    }

    func workoutDuration(for workoutPausedViewController: WorkoutPausedViewController) -> Double {
        return workout.duration
    }

    func workoutLocationHistory(for workoutPausedViewController: WorkoutPausedViewController) -> Set<WorkoutLocation> {
        return workout.locationHistory
    }

}

// MARK: - Managing CLLocationManager

extension WorkoutViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach(workout.addLocation)
        instantVelocity = Double(locationManager.location!.speed)
    }

}
