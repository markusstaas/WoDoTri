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

    @IBOutlet private var primaryActionButton: UIButton!
    @IBOutlet private var pageControl: UIPageControl!

    // MARK: - Handling View Lifecycle

    override func viewDidLoad() {
        super .viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        persistentContainer.loadPersistentStores { _, _ in }
        let workoutType = dataSource.workoutType(for: self)
        workout = Workout(workoutType: workoutType, managedObjectContext: persistentContainer.viewContext)
    }

    // MARK: - Handling Storyboard Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let workoutDataViewController = segue.destination as? WorkoutDataViewController {
            workoutDataViewController.dataSource = self
        }
    }

    @IBAction private func startWorkout() {
        workout.isPaused = false
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
        workout.updateDuration()
        return workout.duration
    }

}

// MARK: - Managing CLLocationManager

extension WorkoutViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach(workout.addLocation)
    }

}
