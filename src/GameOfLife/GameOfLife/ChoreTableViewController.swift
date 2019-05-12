//
//  ChoreTableViewController.swift
//  GameOfLife
//
//  Created by Kari Rye Schougaard on 14/04/2017.
//  Copyright © 2017 Prinsisse. All rights reserved.
//

import UIKit
import os.log

class ChoreTableViewController: UITableViewController {
    
    //Mark: Properties
    var choreData : ChoreDataController = ChoreDataController.instance
    var goalData : GoalDataController = GoalDataController.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Mål"
        } else if section == 1 {
            return "Aktiviteter"
        }
        fatalError("The section of ChoreTableView is unknown.")
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UITableViewHeaderFooterView()
        header.backgroundColor = UIColor.blue
        
        if section == 0 {
            header.setValue("Mål", forKey: "text")
        } else if section == 1 {
            header.setValue("Aktiviteter", forKey: "text")
        } else {
            fatalError("The section of ChoreTableView is unknown.")
        }
        return header
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return goalData.count()
        } else {
            return choreData.count()
        }
    }
        

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ChoreTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? ChoreTableViewCell else {
                fatalError("The dequeued cell is not an instance of ChoreTableViewCell.")
        }

        // Fetches the appropriate goal or chore for the data source layout.
        let section = TableSection(rawValue: indexPath.section)
        if section == TableSection.goals {
            let goal = goalData.get(index: indexPath.row)
            
            cell.nameLabel.text = goal.name
            cell.photoImageView.image = goal.photo
            cell.countLabel.text = "\(truncateFloatToString(goal.currentPoints)) / \(goal.pointsToAchieveGoal)"
            
            return cell
        } else if section == TableSection.chores {
            let chore = choreData.get(index : indexPath.row)

            cell.nameLabel.text = chore.name
            cell.photoImageView.image = chore.photo
            cell.countLabel.text = truncateFloatToString(chore.count)
            return cell
        }
        fatalError("The cell is in an unknown section of ChoreTableView.")
    }

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // disallow deleting by swiping - only allow delete when in edit mode
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let section = TableSection(rawValue: indexPath.section)
            if section == TableSection.goals {
                goalData.delete(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if section == TableSection.chores {
                choreData.delete(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                fatalError("The cell is in an unknown section of ChoreTableView.")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if ( tableView.isEditing) {
            let section = TableSection(rawValue: indexPath.section)
            if section == TableSection.goals {
                self.performSegue(withIdentifier: "ShowGoalDetail", sender:cell);
            } else if section == TableSection.chores {
                // perform segue to edit
                self.performSegue(withIdentifier: "ShowChoreDetail", sender:cell);
            } else {
                fatalError("The cell is in an unknown section of ChoreTableView.")
            }

        } else {
            let section = TableSection(rawValue: indexPath.section)
            if section == TableSection.goals {
                // do nothing
            } else if section == TableSection.chores {
                // when not in edit mode count up
                self.countUp(indexPath: indexPath)
            } else {
                fatalError("The cell is in an unknown section of ChoreTableView.")
            }
        }
    }
    
    enum TableSection: Int {
        case goals = 0, chores, total
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
     
    // MARK: Actions
     
    @IBAction func unwindToChoreList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ChoreViewController, let chore = sourceViewController.chore {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing chore.
                choreData.set(index: selectedIndexPath.row, chore : chore)
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new chore.
                choreData.add(chore : chore)
                let newIndexPath = IndexPath(row: choreData.count()-1, section: 1)

                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                // Redraw Goals to add new chore to Chores for that goal
                // TODO
                
            }
        } else if let sourceViewController = sender.source as? GoalViewController, let goal = sourceViewController.goal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing goal.
                goalData.set(index: selectedIndexPath.row, goal : goal)
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new goal.
                goalData.add(goal : goal)
                let newIndexPath = IndexPath(row: goalData.count()-1, section: 0)

                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
     
     
    // MARK: - Navigation

    // A little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddChore":
                os_log("Adding a new chore.", log: OSLog.default, type: .debug)
            
        case "AddGoal":
            os_log("Adding a new goal.", log: OSLog.default, type: .debug)
            
        case "ShowChoreDetail":
            guard let choreDetailViewController = segue.destination as? ChoreViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedChoreCell = sender as? ChoreTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedChoreCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedChore = choreData.get(index : indexPath.row)
            choreDetailViewController.chore = selectedChore

        case "ShowGoalDetail":
            guard let addGoalDetailViewController = segue.destination as? GoalViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? ChoreTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedGoal = goalData.get(index: indexPath.row)
            addGoalDetailViewController.goal = selectedGoal
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Private Methods
    
    func countUp(indexPath: IndexPath){
        choreData.countUp(index: indexPath.row);
        goalData.countUp(name: choreData.get(index: indexPath.row).name, worth: choreData.get(index: indexPath.row).worth);
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .none)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
        
    func truncateFloatToString(_ float: Float) -> String {
        return float.truncatingRemainder(dividingBy: 1.0) == 0 ? String(Int(floor(float))) : String((float*10).rounded()/10)
    }
}
