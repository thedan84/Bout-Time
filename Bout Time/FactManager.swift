//
//  FactManager.swift
//  Bout Time
//
//  Created by Dennis Parussini on 04-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation
import GameKit

struct FactManager: PlistConverterType {
    
    var facts = [Fact]()
    
    private func getRandomFact() -> Fact {
        var factDict = [String: AnyObject]()
        
        if let allFacts = convertPlistToArray("Facts") {
            let randomInt = GKRandomSource.sharedRandom().nextIntWithUpperBound(allFacts.count)
            factDict = allFacts[randomInt]
        }
        
        return Fact(dictionary: factDict)
    }
    
    mutating func getRandomFacts() {
        
        while facts.count != 4 {
            let randomFact = self.getRandomFact()
            
            while !facts.contains(randomFact) {
                facts.append(randomFact)
            }
        }
    }
    
    func getURLForFact(fact: Fact) -> String {
        return fact.url!
    }
    
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
    
    mutating func swapTwoFacts(fact1: Int, _ fact2: Int) {
        swap(&facts[fact1], &facts[fact2])
    }
}