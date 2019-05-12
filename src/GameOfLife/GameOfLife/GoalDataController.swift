//
//  GoalDataController.swift
//  GameOfLife
//
//  Created by Kari Rye Schougaard on 16/08/2017.
//  Copyright © 2017 Prinsisse. All rights reserved.
//

import UIKit
import os.log

class GoalDataController {
    
    static var instance = GoalDataController()
    
    fileprivate init() {
        loadData()
    }
    
    var goals = [Goal]()
    
    public func count() -> Int {
        return goals.count
    }
    
    public func get(index : Int) -> Goal {
        return goals[index]
    }
    
    public func countUp(name: String, worth: Float){
        for goal in goals {
            if goal.allChoresCount {
                goal.currentPoints = goal.currentPoints + worth
                saveGoals()
            } else if goal.pointGivingChoresArray.contains(name) {
                goal.currentPoints = goal.currentPoints + worth
                saveGoals()
            }
        }
    }
    
    public func delete(index : Int) {
        // Delete the row from the data source
        goals.remove(at: index)
        saveGoals()
    }
        
    public func set(index : Int, goal : Goal){
        goals[index] = goal
        saveGoals()
    }
    
    public func add(goal : Goal){
        goals.append(goal)
        saveGoals()
    }
    
    // MARK: private methods
    
    private func loadData(){
        // Load any saved goals
        if let savedGoals = loadGoals() {
            goals += savedGoals
        }
    }
    
    private func saveGoals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(goals, toFile: Goal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Goals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save goals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadGoals() -> [Goal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Goal.ArchiveURL.path) as? [Goal]
    }
}
