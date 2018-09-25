//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit
import CoreData

final class WorkoutLogViewController: UITableViewController {

    @IBOutlet private var historyTableView: UITableView!
    private var workouts: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Workout Log"
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Workout")
        //let sortDescriptor = NSSortDescriptor(key: "lastUpdateDurationAt", ascending: false)
        //let sortDescriptor = NSSortDescriptor(key: #keyPath(Workout.lastUpdatedDurationAt), ascending: false)
        //fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            workouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workout = workouts[indexPath.row]
        //let workoutDate = workout.value(forKey: "timestampWorkoutStarted") as? String
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = workout.value(forKeyPath: "workoutTypeDescription") as? String
        //cell.detailTextLabel?.text = workout.value(forKey: "timestampWorkoutStarted") as? String
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let workoutLogDetailViewController = segue.destination as? WorkoutLogDetailViewController else {
            preconditionFailure("Unknown segue")
        }
        workoutLogDetailViewController.workout = selectedActivity!

    }

    private var selectedActivity: NSManagedObject? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return workouts[indexPath.row]
    }

}
