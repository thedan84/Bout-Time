//
//  FactManager.swift
//  Bout Time
//
//  Created by Dennis Parussini on 04-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation
import GameKit

// Struct for managing 'Fact' instances, conforms to 'PlistConverterType
struct FactManager: PlistConverterType {
    
    var facts = [Fact]()
    
    // Function to create one random Fact instance, marked private because only this struct needs the func
    fileprivate func getRandomFact() -> Fact? {
        
        if let allFacts = convertPlistToArray("Facts") {
            let randomInt = GKRandomSource.sharedRandom().nextInt(upperBound: allFacts.count)
            return allFacts[randomInt]
        }
        
        return nil
    }
    
    // Function to create the 4 random facts.
    mutating func getRandomFacts() {
        
        // Checks if no random fact is added twice to the facts array
        while facts.count != 4 {
            guard let randomFact = self.getRandomFact() else { return }
            
            while !facts.contains(randomFact) {
                facts.append(randomFact)
            }
        }
    }

    func getURLForFact(_ fact: Fact) -> String {
        return fact.url
    }
    
    // Function to compare the right order of facts to the order the user put in.
    func checkRightOrderOfFacts(_ facts: [Fact]) -> Bool {
        var result = false
        
        let sortedFacts = self.facts.sorted { $0.year < $1.year }
        
        if facts == sortedFacts {
            result = true
        } else {
            result = false
        }
        
        return result
    }

    // Function to swap to facts
    mutating func swapTwoFacts(_ fact1: Int, _ fact2: Int) {
        facts.swapAt(fact1, fact2)
    }
}
