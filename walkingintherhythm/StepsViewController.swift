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
    var myPedometer: CMPedometer!
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var StepsLabel: UILabel!
    @IBOutlet weak var LeftLabel: UILabel!
    @IBOutlet weak var AchieveLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.AchieveLabel.isHidden = true
        self.userDefaults.register(defaults: ["goalStepsaDay": 4000])
        let goalStepsaDay: Int = self.userDefaults.object(forKey: "goalStepsaDay") as! Int
        self.LeftLabel.text = "\(goalStepsaDay)"
        
        countSteps(from: todaysbeginning())
    }
    
    func countSteps(from: Date) {
        let goalStepsaDay: Int = Int(self.LeftLabel.text!)!

        myPedometer = CMPedometer()
        myPedometer.startUpdates(from: from, withHandler: { (data, error) -> Void in
            if error==nil {
                DispatchQueue.main.async(execute: {
                    if data != nil && error == nil {
                        
                        let todaysSteps: Int = Int(data!.numberOfSteps)
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
    
    private func todaysbeginning() -> Date {
        let date = Date()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var beginning = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: date)
        beginning.hour = 0
        beginning.minute = 0
        beginning.second = 0
        let today = calendar.date(from: beginning)
        return today!
    }

}

