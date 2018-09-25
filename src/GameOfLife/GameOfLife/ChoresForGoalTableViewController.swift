//
//  ChoresForGoalTableViewController.swift
//  GameOfLife
//
//  Created by Kari Rye Schougaard on 07/09/2018.
//  Copyright © 2018 Prinsisse. All rights reserved.
//

import UIKit

class ChoresForGoalTableViewController: UITableViewController, ChoreCountsProtocol  {

    //Mark: Properties
    var allChores: [(String,Bool)] = Array()
    
    func setChores(allChores: [String]){
        self.allChores = Array(repeating: ("", false), count: allChores.count)
        for i in 0...allChores.count-1 {
            self.allChores[i] = (allChores[i], true)
        }
    }

    func setValidChores(validChores: [String]){
        for i in 0...allChores.count-1 {
            let name = allChores[i].0
            var isValid = false
            for chore in validChores {
                if name==chore {
                    isValid = true
                    break
                }
            }
            allChores[i].1 = isValid
        }
    }

    func getValidChores() -> [String]{
        var chores: [String] = Array()
        for chore in allChores {
            if chore.1 {
                chores.append(chore.0)
            }
        }
        return chores
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return allChores.count-1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChoresForGoalTableViewCell", for: indexPath) as? ChoresForGoalTableViewCell else {
            fatalError("The dequeued cell is not an instance of ChoresForGoalTableViewCell")
        }

        cell.choreNameLabel.text = self.allChores[indexPath.row].0
        cell.doesCountTowardsChoreSwitch.setOn(self.allChores[indexPath.row].1, animated: false)
        cell.index = indexPath.row
        cell.cellDelegate = self
        return cell
    }

    func getChores() -> [String]{
        var chores: [String] = Array()
        for chore in allChores {
            if chore.1 {
                chores.append(chore.0)
            }
        }
        return chores
    }
    
    //MARK: ChoresValidForGoalDelegate
    public func choreCountsToggled(checked: Bool, index: Int) {
        allChores[index].1 = checked
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
