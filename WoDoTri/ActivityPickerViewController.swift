//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit

final class ActivityPickerViewController: UIViewController, ActivityPageViewControllerWorkoutDelegate {

    private let workout = Workout.shared
    private var selectedWorkoutType: WorkoutType?

    @IBOutlet private var workoutTypeButtonBike: UIButton!
    @IBOutlet private var workoutTypeButtonRun: UIButton!

    @IBAction private func userDidTapWorkoutButton(_ button: UIButton) {
        switch button {
        case workoutTypeButtonBike:
            selectedWorkoutType = .bike
        case workoutTypeButtonRun:
            selectedWorkoutType = .run
        default:
            fatalError("Unknown workout type button")
        }
        performSegue(withIdentifier: "ActivityPageViewController", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let activityPageViewController = segue.destination as? ActivityPageViewController
        activityPageViewController?.workoutDelegate = self
    }

    func workoutType(for activityPageViewController: ActivityPageViewController) -> WorkoutType {
        return selectedWorkoutType!
    }

    @IBAction private func unwindToActivityPickerViewController(with segue: UIStoryboardSegue) {}

}
