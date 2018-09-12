//  Copyright © 2018 Markus Staas. All rights reserved.

import UIKit
import CoreData

protocol WorkoutFinishedViewControllerDataSource: AnyObject {

    func workoutType(for workoutFinishedViewController: WorkoutFinishedViewController) -> WorkoutType
    func workoutDistance(for workoutFinishedViewController: WorkoutFinishedViewController) -> Double
    func workoutDuration(for workoutFinishedViewController: WorkoutFinishedViewController) -> Double
    func workoutLocationHistory(for workoutFinishedViewController: WorkoutFinishedViewController) -> Set<WorkoutLocation>
    func workoutContext(for workoutFinishedViewController: WorkoutFinishedViewController) -> NSManagedObjectContext
}

class WorkoutFinishedViewController: UIViewController {

    weak var dataSource: WorkoutFinishedViewControllerDataSource?

    @IBAction func saveWorkoutToLog(_ sender: Any) {
        let context = dataSource?.workoutContext(for: self)
        if (context?.hasChanges)! {
            do {
                try context?.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
