//
//  SettingsTableViewController.swift
//  walkingintherhythm
//
//  Created by amotz on 2016/08/31.
//  Copyright © 2016年 amotz. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: Properties
    @IBOutlet weak var GoalStepsLabel: UILabel!

    let userDefaults = UserDefaults.standard

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        userDefaults.register(defaults: ["goalStepsaDay": 4000])
        let goalStepsaDay: Int = userDefaults.object(forKey: "goalStepsaDay") as! Int
        GoalStepsLabel.text = goalStepsaDay.description
    }
    
}
