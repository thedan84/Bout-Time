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
    private func getRandomFact() -> Fact {
        var factDict = [String: AnyObject]()
        
        if let allFacts = convertPlistToArray("Facts") {
            let randomInt = GKRandomSource.sharedRandom().nextIntWithUpperBound(allFacts.count)
            factDict = allFacts[randomInt]
        }
        
        return Fact(dictionary: factDict)
    }
    
    // Function to create the 4 random facts.
    mutating func getRandomFacts() {
        
        // Checks if no random fact is added twice to the facts array
        while facts.count != 4 {
            let randomFact = self.getRandomFact()
            
            while !facts.contains(randomFact) {
                facts.append(randomFact)
            }
        }
    }
    
    // Function to get the URL for the chosen fact. Returns the url string.
    func getURLForFact(fact: Fact) -> String {
        return fact.url!
    }
    
    // Function to compare the right order of facts to the order the user put in.
    func checkRightOrderOfFacts(facts: [Fact]) -> Bool {
        var result = false
        
        let sortedFacts = self.facts.sort { $0.year < $1.year }
        
        if facts == sortedFacts {
            result = true
        } else {
            result = false
        }
        
        return result
    }
    
    // Function to swap to facts
    mutating func swapTwoFacts(fact1: Int, _ fact2: Int) {
        swap(&facts[fact1], &facts[fact2])
    }
}