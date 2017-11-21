//
//  ActivityViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/10/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    let stopwatch = StopWatch()
    let speedo = SpeedoMat()
    var activityType = "Running"
    @IBOutlet weak var startButt: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var pausedLabel: UILabel!
    
    func tick() {
        elapsedTimeLabel.text = stopwatch.elapsedTimeAsString()
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if stopwatch.stopwatchStatus == "Stopped" || stopwatch.stopwatchStatus == "Paused"{
            stopwatch.start()
            startButt.backgroundColor = UIColor.orange
            startButt.setTitle("Pause", for: .normal)
            if stopwatch.stopwatchStatus == "Paused"{
                pausedLabel.isHidden = true
            }
        }else{
            stopwatch.stop()
            startButt.backgroundColor = UIColor.green
            startButt.setTitle("Start", for: .normal)
            pausedLabel.isHidden = false
        }
    }
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopwatch.stop()
        performSegue(withIdentifier: "FinishView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tick()
        stopwatch.callback = self.tick
        pausedLabel.isHidden = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FinishView") {
            let viewController = segue.destination as! FinishViewController
            viewController.elapsedTime = stopwatch.elapsedTimeAsString()
        }
    }

}
