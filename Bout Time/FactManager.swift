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
    
    fileprivate func getRandomFact() -> Fact {
        var factDict = [String: AnyObject]()
        
        if let allFacts = convertPlistToArray("Facts") {
            let randomInt = GKRandomSource.sharedRandom().nextInt(upperBound: allFacts.count)
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
    
    func getURLForFact(_ fact: Fact) -> String {
        return fact.url!
    }
    
    func checkRightOrderOfFacts(_ facts: [Fact]) -> Bool {
        var result = false
        
        let sortedFacts = self.facts.sorted { $0.year! < $1.year! }
        
        if facts == sortedFacts {
            result = true
        } else {
            result = false
        }
        
        return result
    }
    
    mutating func swapTwoFacts(_ fact1: Int, _ fact2: Int) {
        swap(&facts[fact1], &facts[fact2])
    }
}
