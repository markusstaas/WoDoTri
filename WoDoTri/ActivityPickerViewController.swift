//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit

final class ActivityPickerViewController: UIViewController {

    private let workout = Workout.shared

    @IBAction private func bikeButtonPressed(_ sender: Any) {
        workout.activityType = .bike
        performSegue(withIdentifier: "ActivityPageViewController", sender: self)
    }

    @IBAction private func runButtonPressed(_ sender: Any) {
        workout.activityType = .run
        performSegue(withIdentifier: "ActivityPageViewController", sender: self)
    }

    @IBAction private func unwindToActivityPickerViewController(with segue: UIStoryboardSegue) {}

}
