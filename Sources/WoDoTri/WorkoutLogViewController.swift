//  Copyright © 2017 Markus Staas. All rights reserved.

import UIKit
import CoreData

final class WorkoutLogViewController: UITableViewController {

    @IBOutlet private var historyTableView: UITableView!
    private var workouts: [NSManagedObject] = []
    private let workoutLogDetailViewControllerSegueIdentifier = "Workout Detail Log View Controller Segue"

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
        let sortDescriptor = NSSortDescriptor(key: "workoutStartedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = workout.value(forKeyPath: "workoutTypeDescription") as? String
        let workoutDate = workout.value(forKeyPath: "workoutStartedAt")
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = .medium
        // swiftlint:disable force_cast
        let dateString = formatter.string(from: workoutDate as! Date)
        cell.detailTextLabel?.text = dateString
        return cell
    }

    // MARK: - Handling Storyboard Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let workoutLogDetailViewController = segue.destination as? WorkoutLogDetailViewController {
            workoutLogDetailViewController.workout = selectedActivity!
        }
    }

    private var selectedActivity: NSManagedObject? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return workouts[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: workoutLogDetailViewControllerSegueIdentifier, sender: self)
    }

}
