//
//  TodayViewController.swift
//  walkingintherhythmWidget
//
//  Created by amotz on 2016/11/22.
//  Copyright © 2016年 amotz. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreMotion

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // MARK: Properties
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var StepsLabel: UILabel!
    @IBOutlet weak var LeftLabel: UILabel!

    @objc let userDefaults: UserDefaults = UserDefaults(suiteName: "group.com.amotzbeats.walkingintherhythm")!
    @objc let myPedometer: CMPedometer = {
        return CMPedometer()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let startOfToday: Date = Calendar(identifier: .gregorian).startOfDay(for: Date())
        countSteps(from: startOfToday)
    }
    
    @objc func countSteps(from: Date) {
        guard CMPedometer.isStepCountingAvailable() else {
            return
        }

        DispatchQueue.global().async {
            self.userDefaults.register(defaults: ["goalStepsaDay": 4000])
            let goalStepsaDay: Int = self.userDefaults.object(forKey: "goalStepsaDay") as! Int
            
            self.myPedometer.startUpdates(from: from, withHandler: { (data, error) -> Void in
                if data != nil && error == nil {
                    
                    DispatchQueue.main.async {
                        let todaysSteps: Int = Int(Int(truncating: data!.numberOfSteps))
                        self.StepsLabel.text = "\(todaysSteps) steps"
                        
                        var stepsToGo: Int
                        if goalStepsaDay <= todaysSteps {
                            stepsToGo = 0
                        } else {
                            stepsToGo = goalStepsaDay - todaysSteps
                        }
                        self.LeftLabel.text = "\(stepsToGo) steps left"
                        
                        if stepsToGo==0 {
                            self.StatusLabel.text = "😊"
                        } else {
                            self.StatusLabel.text = "💪"
                        }
                    }
                }

            })
        }
    }
    
}
