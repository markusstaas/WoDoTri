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
    @IBOutlet weak var startButt: UIButton!
    
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    func tick() {
        elapsedTimeLabel.text = stopwatch.elapsedTimeAsString()
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if stopwatch.stopwatchStatus == "Stopped" || stopwatch.stopwatchStatus == "Paused"{
            stopwatch.start()
            startButt.backgroundColor = UIColor.orange
            startButt.setTitle("Pause", for: .normal)
        }else{
            stopwatch.stop()
            startButt.backgroundColor = UIColor.green
            startButt.setTitle("Start", for: .normal)
        }
    }
 
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopwatch.stop()
          performSegue(withIdentifier: "FinishView", sender: self)
        print(stopwatch.stopwatchStatus)
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tick()
        stopwatch.callback = self.tick
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FinishView") {
            let viewController = segue.destination as! FinishViewController
            viewController.elapsedTime = stopwatch.elapsedTimeAsString()
        }
    }

}
