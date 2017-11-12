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
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    func tick() {
        elapsedTimeLabel.text = stopwatch.elapsedTimeAsString()
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        stopwatch.start()
    }
 
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopwatch.stop()
          performSegue(withIdentifier: "FinishView", sender: self)
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tick()
        stopwatch.callback = self.tick
        print(speedo.test)
        
        

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FinishView") {
            let viewController = segue.destination as! FinishViewController
            viewController.elapsedTime = stopwatch.elapsedTimeAsString()
        }
    }

}
