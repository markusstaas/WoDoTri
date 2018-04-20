import UIKit

protocol WorkoutViewControllerDelegate: AnyObject {

    func workoutType(for workoutViewController: WorkoutViewController) -> WorkoutType

}

final class WorkoutViewController: UIViewController, UIScrollViewDelegate {

    weak var delegate: WorkoutViewControllerDelegate?

    @IBOutlet private var primaryActionButton: UIButton!
    @IBOutlet private var pageControl: UIPageControl!

    // MARK: - Managing Scroll View

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        precondition(pageControl.numberOfPages == 2)
        let horizontalScrollOffset = scrollView.contentOffset.x
        let horizontalMiddleOffset = scrollView.frame.width / 2
        let isPastMiddle = horizontalScrollOffset < horizontalMiddleOffset
        pageControl.currentPage = isPastMiddle ? 0 : 1
    }

}
