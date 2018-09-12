//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit
import CoreData

protocol StartWorkoutButtonDelegate: AnyObject {

    func startOrPauseWorkout()
}

protocol WorkoutPausedViewControllerDataSource: AnyObject {

    func workoutType(for workoutPausedViewController: WorkoutPausedViewController) -> WorkoutType
    func workoutDistance(for workoutPausedViewController: WorkoutPausedViewController) -> Double
    func workoutDuration(for workoutPausedViewController: WorkoutPausedViewController) -> Double
    func workoutLocationHistory(for workoutPausedViewController: WorkoutPausedViewController) -> Set<WorkoutLocation>
    func workoutContext(for workoutPausedViewController: WorkoutPausedViewController) -> NSManagedObjectContext

}

class WorkoutPausedViewController: UIViewController {

    weak var delegate: StartWorkoutButtonDelegate?
    weak var dataSource: WorkoutPausedViewControllerDataSource?

    private var workoutFinishedViewController: WorkoutFinishedViewController?
    private let workoutFinishedViewControllerSegueIdentifier = "Workout Finished View Controller Segue"

    @IBAction func startWorkout() {
        self.delegate?.startOrPauseWorkout()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func finishWorkout() {
        performSegue(withIdentifier: workoutFinishedViewControllerSegueIdentifier, sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Handling Storyboard Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destinationWorkoutFinishedViewController = segue.destination as? WorkoutFinishedViewController {
            workoutFinishedViewController = destinationWorkoutFinishedViewController
            destinationWorkoutFinishedViewController.dataSource = self
        }
    }

}

// MARK: - Managing WorkoutFinishedViewController

extension WorkoutPausedViewController: WorkoutFinishedViewControllerDataSource {

    func workoutContext(for workoutFinishedViewController: WorkoutFinishedViewController) -> NSManagedObjectContext {
        return (dataSource?.workoutContext(for: self))!
    }

    func workoutType(for workoutFinishedViewController: WorkoutFinishedViewController) -> WorkoutType {
        return (dataSource?.workoutType(for: self))!
    }

    func workoutDistance(for workoutFinishedViewController: WorkoutFinishedViewController) -> Double {
        return (dataSource?.workoutDistance(for: self))!
    }

    func workoutDuration(for workoutFinishedViewController: WorkoutFinishedViewController) -> Double {
        return (dataSource?.workoutDuration(for: self))!
    }

    func workoutLocationHistory(for workoutFinishedViewController: WorkoutFinishedViewController) -> Set<WorkoutLocation> {
        return (dataSource?.workoutLocationHistory(for: self))!
    }

}
