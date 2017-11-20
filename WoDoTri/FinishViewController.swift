//
//  FinishViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 11/12/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {
    let stopwatch = StopWatch()
    
    var elapsedTime = "0.0"
    
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        elapsedTimeLabel.text = elapsedTime
    }

    @IBAction func finishButtonPressed(_ sender: Any) {
    }

    @IBAction func discardButtonPressed(_ sender: Any) {
        stopwatch.reset()
    }

}
