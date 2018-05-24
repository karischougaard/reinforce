//
//  GameOfLifeTests.swift
//  GameOfLifeTests
//
//  Created by Kari Rye Schougaard on 06/04/2017.
//  Copyright © 2017 Prinsisse. All rights reserved.
//

import XCTest
@testable import GameOfLife

class GameOfLifeTests: XCTestCase {
    
    //MARK: Chore Class Tests

    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testChoreInitializationSucceeds() {
        // Zero count
        let zeroCountChore = Chore.init(name: "Zero", photo: nil, count: 0)
        XCTAssertNotNil(zeroCountChore)
        
        // Positive count
        let positiveCountChore = Chore.init(name: "Positive", photo: nil, count: 5)
        XCTAssertNotNil(positiveCountChore)
    }
    
 
    // Confirm that the Meal initialier returns nil when passed a negative count or an empty name.
    func testMealInitializationFails() {
        // Negative count
        let negativeCountChore = Chore.init(name: "Negative", photo: nil, count: -1)
        XCTAssertNil(negativeCountChore)
        
        // Empty String
        let emptyStringMeal = Chore.init(name: "", photo: nil, count: 0)
        XCTAssertNil(emptyStringMeal)
    }
}
