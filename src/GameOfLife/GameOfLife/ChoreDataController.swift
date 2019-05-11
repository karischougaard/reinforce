//
//  ChoreDataController.swift
//  GameOfLife
//
//  Created by Kari Rye Schougaard on 16/08/2017.
//  Copyright © 2017 Prinsisse. All rights reserved.
//

import UIKit
import os.log

class ChoreDataController {
    
    static var instance = ChoreDataController()
    
    fileprivate init() {
        loadData()
    }
    
    var chores = [Chore]()
    
    public func count() -> Int {
        return chores.count
    }

    public func get(index : Int) -> Chore {
        return chores[index]
    }
    
    public func getNames() -> [String] {
        var names: [String] = Array()
        for i in 0...chores.count-1 {
            names.append(chores[i].name)
        }
        return names
    }
    
    public func delete(index : Int) {
        // Delete the row from the data source
        chores.remove(at: index)
        saveChores()
    }
    
    public func countUp(index : Int) {
        chores[index].count += 1
        saveChores()
    }
    
    public func set(index : Int, chore : Chore){
        chores[index] = chore
        saveChores()
    }
    
    public func add(chore : Chore){
        chores.append(chore)
        saveChores()
    }
    
    // MARK: private methods

    private func loadData(){
    // Load any saved meals, otherwise load sample data.
        if let savedChores = loadChores() {
            chores += savedChores
        } else {
            // Load the sample data.
            loadSampleChores()
        }
    }
    
    private func loadSampleChores() {
        
        chores = []
        
        guard let dishWash = Chore(name: "Vaske op", worth: 1.0, photo: UIImage(named: "dishWashing"), count: 0) else {
            fatalError("Unable to instantiate vaske op")
        }
        chores.append(dishWash)
        
        guard let dress = Chore(name: "Klæde sig af og på", worth: 1.0, photo: UIImage(named: "kidDressing"), count: 0) else {
            fatalError("Unable to instantiate klæde sig på")
        }
        chores.append(dress)
        
        guard let cook = Chore(name: "Lave mad", worth: 1.0, photo: UIImage(named: "food"), count: 0) else {
            fatalError("Unable to instantiate lave mad")
        }
        chores.append(cook)
        
        guard let tidy = Chore(name: "Rydde op", worth: 1.0, photo: UIImage(named: "tidyUp"), count: 0) else {
            fatalError("Unable to instantiate rydde op")
        }
        chores.append(tidy)
        
        guard let setTheTable = Chore(name: "Dække bord", worth: 1.0, photo: UIImage(named: "setTable"), count: 0) else {
            fatalError("Unable to instantiate dække bord")
        }
        chores.append(setTheTable)
        
        guard let clearTheTable = Chore(name: "Tage af bordet", worth: 1.0, photo: UIImage(named: "clearTable"), count: 0) else {
            fatalError("Unable to instantiate Tage af bordet")
        }
        chores.append(clearTheTable)
        
        guard let eat = Chore(name: "Rasmus: spise et måltid", worth: 1.0, photo: UIImage(named: "eat"), count: 0) else {
            fatalError("Unable to instantiate Rasmus: spise et måltid")
        }
        chores.append(eat)
        
        guard let meet = Chore(name: "Rasmus: møde i skole inden 9", worth: 1.0, photo: UIImage(named: "nineOClock"), count: 0) else {
            fatalError("Unable to instantiate Rasmus: møde i skole inden 9")
        }
        chores.append(meet)

        /*
        chores.append(Chore(name: "Eva Marie: rede hår", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Eva Marie: Få redt uglet hår (med skærm)", photo: nil, count: 0)!)
        chores.append(Chore(name: "Selv gå i bad", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Putte et barn", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Tørre borde af", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Gøre noget man ikke er vant til", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Gå i skole", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Gå på arbejde", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Lave skolearbejde i 20 minutter", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Læse i 20 minutter", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Bage", photo: nil, worth: 1.0, count: 0)!)
        chores.append(Chore(name: "Rydde op i sine gamle papirer", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Gå ud med skrald", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Vaske tøj", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Lægge tøj sammen", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Lægge tøj på plads i skabet", worth: 1.0, worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Afbryde det man er i gang med pa opfordring", photo: nil, count: 0)!)
        chores.append(Chore(name: "Havearbejde", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Fikse noget i huset", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Gøre rent", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Pynte fx hænge billede op", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Handle", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Lave indkøbsseddel", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Ordne økonomi", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Særlige opgaver", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Vande blomster", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Træne/motion", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Gøre noget man ikke har lyst til (læge/tandlæge fx)", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Aflevere biblioteksbøger", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Bonus point for god gerning", worth: 1.0, photo: nil, count: 0)!)
        chores.append(Chore(name: "Bonus point for at gøre noget særligt godt", worth: 1.0, photo: nil, count: 0)!)
        */
    }
    
    private func saveChores() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(chores, toFile: Chore.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Chores successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save chores...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadChores() -> [Chore]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Chore.ArchiveURL.path) as? [Chore]
    }

}
