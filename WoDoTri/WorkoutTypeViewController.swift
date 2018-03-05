//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit

final class WorkoutTypeViewController: UIViewController {

    @IBOutlet private var workoutTypeButtonBike: UIButton!
    @IBOutlet private var workoutTypeButtonRun: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard
            let button = sender as? UIButton,
            let workoutViewController = segue.destination as? WorkoutViewController else {
            preconditionFailure()
        }
        let workoutType: WorkoutType
        switch button {
        case workoutTypeButtonBike: workoutType = .bike
        case workoutTypeButtonRun: workoutType = .run
        default: preconditionFailure()
        }
        workoutViewController.preconfigure(with: workoutType)
    }

    @IBAction private func unwindToActivityPickerViewController(with segue: UIStoryboardSegue) {}

}
