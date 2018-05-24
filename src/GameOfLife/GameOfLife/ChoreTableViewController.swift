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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choreData.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ChoreTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? ChoreTableViewCell else {
                fatalError("The dequeued cell is not an instance of ChoreTableViewCell.")
        }

        // Fetches the appropriate chore for the data source layout.
        let chore = choreData.get(index : indexPath.row)

        cell.nameLabel.text = chore.name
        cell.photoImageView.image = chore.photo
        cell.countLabel.text = String(chore.count)
        return cell
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
            choreData.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Find the selected cell in the usual way
        let cell = tableView.cellForRow(at: indexPath)
        
        if ( tableView.isEditing) {
            // perform segue to edit
            self.performSegue(withIdentifier: "ShowDetail", sender:cell);
        } else {
            // when not in edit mode count up
            choreData.countUp(index : indexPath.row);
            tableView.reloadRows(at: [indexPath], with: .none)
        }
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
                let newIndexPath = IndexPath(row: choreData.count(), section: 0)
                
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
            
        case "ShowDetail":
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
            
        case "AddGoal":
            os_log("Adding a new goal.", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Private Methods

}
