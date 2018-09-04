//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit

protocol StartWorkoutButtonDelegate: AnyObject {
    func startOrPauseWorkout()
}

class WorkoutPausedViewController: UIViewController {

    weak var delegate: StartWorkoutButtonDelegate?

    @IBAction func startWorkout() {
        self.delegate?.startOrPauseWorkout()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func finishWorkout() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
