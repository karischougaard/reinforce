//
//  Chore.swift
//  GameOfLife
//
//  Created by Kari Rye Schougaard on 11/04/2017.
//  Copyright © 2017 Prinsisse. All rights reserved.
//

import UIKit
import os.log

class Chore : NSObject, NSCoding {
    
    // MARK: Properties
    var name: String
    var worth: Float
    var photo: UIImage?
    var count: Float
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("chores")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let worth = "worth"
        static let photo = "photo"
        static let count = "count"
    }
    
    //MARK: Initialization
    
    init?(name: String, worth: Float, photo: UIImage?, count: Float) {
        
        // Initialization should fail if there is no name or if the count is negative.
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.worth = worth
        self.photo = photo
        self.count = count
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(worth, forKey: PropertyKey.worth)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(count, forKey: PropertyKey.count)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Chore object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // If worth does not exist it is set to 1        
        var worth = aDecoder.decodeFloat(forKey: PropertyKey.worth)
        if (worth == 0.0) {
            worth = 1.0
        }
        
        // Because photo is an optional property of Chore, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let count = aDecoder.decodeFloat(forKey: PropertyKey.count)
        
        // Must call designated initializer.
        self.init(name: name, worth: worth, photo: photo, count: count)
    }
}
