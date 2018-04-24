import UIKit

// swiftlint:disable force_cast
// swiftlint:disable line_length

final class WorkoutDataViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MeasurementTableViewCell.preferredNib, forCellReuseIdentifier: MeasurementTableViewCell.preferredReuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeasurementTableViewCell.preferredReuseIdentifier, for: indexPath) as! MeasurementTableViewCell
        cell.updateMeasurement(property: "My cool property", value: "100", unit: "Cool")
        return cell
    }

//    override init() {
//        super.init()
//        self.displayLink = CADisplayLink(target: self, selector: #selector(tick(sender:)))
//        displayLink.isPaused = true
//        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
//        self.elapsedTime = 0.0
//        formatter.timeZone = TimeZone(abbreviation: "GMT")!
//        formatter.dateFormat = "HH:mm:ss"
//    }
//
//    deinit {
//        displayLink.invalidate()
//    }
//    @objc private func tick(sender: CADisplayLink) {
//        elapsedTime = elapsedTime + displayLink.duration
//        callback?()
//    }

}
