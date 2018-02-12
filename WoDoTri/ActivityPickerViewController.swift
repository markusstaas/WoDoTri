//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit

final class ActivityPickerViewController: UIViewController {

    private let workoutData = Workout.shared

    @IBAction private func bikeButtonPressed(_ sender: Any) {
        workoutData.activityType = .bike
        performSegue(withIdentifier: "ActivityPageViewController", sender: self)
    }

    @IBAction private func runButtonPressed(_ sender: Any) {
        workoutData.activityType = .run
        performSegue(withIdentifier: "ActivityPageViewController", sender: self)
    }

}
