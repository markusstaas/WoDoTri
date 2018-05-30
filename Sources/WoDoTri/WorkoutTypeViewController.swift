//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit

// swiftlint:disable force_cast

final class WorkoutTypeViewController: UIViewController {

    private var workoutType: WorkoutType?
    private let workoutViewControllerSegueIdentifier = "Workout View Controller Segue"

    // MARK: - Handling Interface Builder Actions

    @IBAction private func pickWorkoutTypeRide() {
        workoutType = .ride
        performSegue(withIdentifier: workoutViewControllerSegueIdentifier, sender: self)
    }

    @IBAction private func pickWorkoutTypeRun() {
        workoutType = .run
        performSegue(withIdentifier: workoutViewControllerSegueIdentifier, sender: self)
    }

    // MARK: - Handling Storyboard Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let workoutViewController = segue.destination as! WorkoutViewController
        workoutViewController.dataSource = self
    }

}

// MARK: - Managing WorkoutViewController

extension WorkoutTypeViewController: WorkoutViewControllerDataSource {

    func workoutType(for workoutViewController: WorkoutViewController) -> WorkoutType {
        return workoutType!
    }

}
