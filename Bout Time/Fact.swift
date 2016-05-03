//
//  Fact.swift
//  Bout Time
//
//  Created by Dennis Parussini on 03-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation
import GameKit

struct Fact: PlistConverterType {
    var fact: String?
    var year: Int?
    var url: String?
    
    init(dictionary: [String: AnyObject]) {
        self.fact = dictionary["fact"] as? String
        self.year = dictionary["year"] as? Int
        self.url = dictionary["url"] as? String
    }
    
    init() {}
    
    mutating func getRandomFact() -> Fact {
        var factDict = [String: AnyObject]()
        
        if let allFacts = convertPlistToArray("Facts") {
            let randomInt = GKRandomSource.sharedRandom().nextIntWithUpperBound(allFacts.count)
            factDict = allFacts[randomInt]
        }
        
        return Fact(dictionary: factDict)
    }
}