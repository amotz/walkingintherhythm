//
//  GoalStepsTableViewController.swift
//  walkingintherhythm
//
//  Created by amotz on 2016/09/04.
//  Copyright © 2016年 amotz. All rights reserved.
//

import UIKit

class GoalStepsTableViewController: UITableViewController {
    
    // MARK: Properties
    @objc let userDefaults: UserDefaults = UserDefaults(suiteName: Const().suiteName)!
    @objc let cellLabels = ["4000", "5000", "7000", "8000"]
 
    @objc var checkMarks = [false, false, false, false]
    @objc var goalStepsaDay: Int = 0
    
    override func viewDidLoad() {
        userDefaults.register(defaults: ["goalStepsaDay": 4000])
        goalStepsaDay = userDefaults.object(forKey: "goalStepsaDay") as! Int
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 1 {
            return cellLabels.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section < 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            if (indexPath as NSIndexPath).row < cellLabels.count {
                cell.textLabel?.text = cellLabels[(indexPath as NSIndexPath).row]
                if goalStepsaDay == Int((cell.textLabel?.text)!)! {
                    cell.accessoryType = .checkmark
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                }
            }
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.white
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < 1 {
            return "Goal steps / Day"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section > 0 { return }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                
                //Save settings.
                let goalSteps: Int = Int((cell.textLabel?.text)!)!
                userDefaults.set(goalSteps, forKey: "goalStepsaDay")
                userDefaults.synchronize()
                
                checkMarks = checkMarks.enumerated().flatMap { (elem: (Int, Bool)) -> Bool in
                    if (indexPath as NSIndexPath).row != elem.0 {
                        let otherCellIndexPath = IndexPath(row: elem.0, section: 0)
                        if let otherCell = tableView.cellForRow(at: otherCellIndexPath) {
                            otherCell.accessoryType = .none
                            otherCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
                            otherCell.textLabel?.textColor = UIColor.black
                        }
                    }
                    return (indexPath as NSIndexPath).row == elem.0
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
