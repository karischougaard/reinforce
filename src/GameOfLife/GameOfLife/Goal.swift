//
//  Goal.swift
//  GameOfLife
//
//  Created by Kari Rye Schougaard on 16/08/2017.
//  Copyright © 2017 Prinsisse. All rights reserved.
//

import UIKit
import os.log

class Goal : NSObject, NSCoding {
    
    // MARK: Properties
    
    var name: String
    var pointsToAchieveGoal: Int
    var currentPoints: Int
    var pointGivingChoresArray: [String]
    var photo: UIImage?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Goals")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let pointsToAchieveGoal = "pointsToAchieveGoal"
        static let currentPoints = "currentPoints"
        static let pointGivingChores = "pointGivingChores"
    }
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, pointsToAchieveGoal: Int, currentPoints: Int, pointGivingChoresArray: [String]) {
        
        // Initialization should fail if there is no name or if the pointsToAchieveGoal is negative.
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The pointsToAchieveGoal must be 0 or more
        guard (pointsToAchieveGoal > 0) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.pointsToAchieveGoal = pointsToAchieveGoal
        self.currentPoints = currentPoints
        self.pointGivingChoresArray = pointGivingChoresArray
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(pointsToAchieveGoal, forKey: PropertyKey.pointsToAchieveGoal)
        aCoder.encode(currentPoints, forKey: PropertyKey.currentPoints)
        aCoder.encode(pointGivingChoresArray, forKey: PropertyKey.pointGivingChores)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Goal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Goal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let pointsToAchieveGoal = aDecoder.decodeInteger(forKey: PropertyKey.pointsToAchieveGoal)
        
        let currentPoints = aDecoder.decodeInteger(forKey: PropertyKey.currentPoints)
        
        // At least one chore is required. If we cannot decode a Chore, the initializer should fail
        guard let pointGivingChoresArray = aDecoder.decodeObject(forKey: PropertyKey.pointGivingChores) as? [String] else {
            os_log("Unable to decode the array of Chores for a Goal object.", log: OSLog.default, type: .debug)
            return nil
        }

        // Must call designated initializer.
        self.init(name: name, photo: photo, pointsToAchieveGoal: pointsToAchieveGoal, currentPoints: currentPoints, pointGivingChoresArray: pointGivingChoresArray)
    }
}
