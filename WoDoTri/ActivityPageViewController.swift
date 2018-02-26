//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit

protocol ActivityPageViewControllerWorkoutDelegate: class {

    func workoutType(for activityPageViewController: ActivityPageViewController) -> WorkoutType

}


final class ActivityPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private let pages = ["ActivityView", "ActivityMapView"]

    weak var workoutDelegate: ActivityPageViewControllerWorkoutDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        Workout.shared.activityType = workoutDelegate!.workoutType(for: self)
        self.delegate = self
        self.dataSource = self
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivityView")
        setViewControllers([vc!], // Has to be a single item array, unless you're doing double sided stuff I believe
            direction: .forward,
            animated: true,
            completion: nil)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index > 0 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index-1])
                }
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index < pages.count - 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                return index
            }
        }
        return 0
    }

}
