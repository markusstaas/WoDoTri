import UIKit
import CoreData
import CoreLocation

protocol WorkoutViewControllerDataSource: AnyObject {

    func workoutType(for workoutViewController: WorkoutViewController) -> WorkoutType

}

final class WorkoutViewController: UIViewController {

    weak var dataSource: WorkoutViewControllerDataSource!

    private var workout: Workout!
    private let persistentContainer = NSPersistentContainer(name: "WorkoutLog")
    private let locationManager = CLLocationManager()
    private var updateTimer: Timer!
    private let updateInterval: TimeInterval = 0.1
    private var workoutDataViewController: WorkoutDataViewController?

    @IBOutlet private var primaryActionButton: UIButton!
    @IBOutlet private var pageControl: UIPageControl!

    // MARK: - Handling View Lifecycle

    override func viewDidLoad() {
        super .viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        persistentContainer.loadPersistentStores { _, _ in }
        let workoutType = dataSource.workoutType(for: self)
        workout = Workout(workoutType: workoutType, managedObjectContext: persistentContainer.viewContext)
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.workout.updateDuration()
            self?.workoutDataViewController?.updateView()
        }
    }

    // MARK: - Handling Storyboard Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationWorkoutDataViewController = segue.destination as? WorkoutDataViewController {
            destinationWorkoutDataViewController.dataSource = self
            workoutDataViewController = destinationWorkoutDataViewController
        }
    }

    @IBAction private func startWorkout() {
        workout.isPaused = false
        workout.updateDuration()
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

}

// MARK: - Managing CLLocationManager

extension WorkoutViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach(workout.addLocation)
    }

}
