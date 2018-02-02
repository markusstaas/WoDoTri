//
//  HistoryViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/10/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit
import CoreData

final class HistoryViewController: UITableViewController {

    @IBOutlet private var historyTableView: UITableView!
    private var activities: [Activity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Past Workouts"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let entity = NSEntityDescription.entity(forEntityName: "Activity", in: CoreDataStack.context)
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Activity.timestamp), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            activities = try CoreDataStack.context.fetch(fetchRequest)

        } catch  let error {
            //handle error
            print(error)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workout = activities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = FormatDisplay.date(workout.value(forKey: "timestamp") as? Date)
        cell.detailTextLabel?.text = workout.value(forKey: "type") as? String
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let activityDetailViewController = segue.destination as? ActivityDetailViewController else {
            preconditionFailure("Unknown segue")
        }
        activityDetailViewController.activity = selectedActivity!
    }

    private var selectedActivity: Activity? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        return activities[indexPath.row]
    }
}
