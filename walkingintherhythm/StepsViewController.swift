//
//  StepsViewController.swift
//  walkingintherhythm
//
//  Created by amotz on 2016/06/29.
//  Copyright © 2016年 amotz. All rights reserved.
//

import UIKit
import CoreMotion

class StepsViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var StepsLabel: UILabel!
    @IBOutlet weak var LeftLabel: UILabel!
    @IBOutlet weak var AchieveLabel: UILabel!
    
    @objc let userDefaults: UserDefaults = UserDefaults(suiteName: Const().suiteName)!
    @objc var myPedometer: CMPedometer!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.AchieveLabel.isHidden = true
        self.userDefaults.register(defaults: ["goalStepsaDay": 4000])
        let goalStepsaDay: Int = self.userDefaults.object(forKey: "goalStepsaDay") as! Int
        self.LeftLabel.text = "\(goalStepsaDay)"
        
        let startOfToday: Date = Calendar(identifier: .gregorian).startOfDay(for: Date())
        countSteps(from: startOfToday)
    }
    
    @objc func countSteps(from: Date) {
        let goalStepsaDay: Int = Int(self.LeftLabel.text!)!

        myPedometer = CMPedometer()
        myPedometer.startUpdates(from: from, withHandler: { (data, error) -> Void in
            if error==nil {
                DispatchQueue.main.async(execute: {
                    if data != nil && error == nil {
                        
                        let todaysSteps: Int = Int(truncating: data!.numberOfSteps)
                        self.StepsLabel.text = "\(todaysSteps)"
                        
                        var stepsToGo: Int
                        if goalStepsaDay <= todaysSteps {
                          stepsToGo = 0
                        } else {
                          stepsToGo = goalStepsaDay - todaysSteps
                        }
                        self.LeftLabel.text = "\(stepsToGo)"
                        
                        if stepsToGo==0 {
                            self.AchieveLabel.isHidden = false
                        }
                        
                    }
                })
            }
            
        })
    }

}

