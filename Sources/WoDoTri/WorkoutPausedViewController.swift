//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit

protocol StartWorkoutButtonDelegate: AnyObject {
    func startOrPauseWorkout()
}

class WorkoutPausedViewController: UIViewController {

    weak var delegate: StartWorkoutButtonDelegate?

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
            //destinationWorkoutPausedViewController.delegate = self
        }
    }

}
