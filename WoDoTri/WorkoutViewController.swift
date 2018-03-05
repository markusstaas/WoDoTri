import UIKit

final class WorkoutViewController: UIViewController {

    func preconfigure(with workoutType: WorkoutType) {
        precondition(isViewLoaded == false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // ask delegate
    }

}
