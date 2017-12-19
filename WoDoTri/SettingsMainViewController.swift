//
//  SettingsMainViewController.swift
//  WoDoTri
//
//  Created by Markus Staas on 12/19/17.
//  Copyright © 2017 Markus Staas. All rights reserved.
//

import UIKit

class SettingsMainViewController: UIViewController, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let workout = activities[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "settingsCell")
        cell.textLabel?.text = "test"
        cell.detailTextLabel?.text = "more test"
        return cell
    }

}
