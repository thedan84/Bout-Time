//
//  Fact.swift
//  Bout Time
//
//  Created by Dennis Parussini on 03-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

struct Fact {
    var fact: String?
    var year: Int?
    var url: String?
    
    init(dictionary: [String: AnyObject]) {
        self.fact = dictionary["fact"] as? String
        self.year = dictionary["year"] as? Int
        self.url = dictionary["url"] as? String
    }
    
    init() {}
}

extension Fact: Equatable {}

func ==(lhs: Fact, rhs: Fact) -> Bool {
    return lhs.fact == rhs.fact && lhs.year == rhs.year && lhs.url == rhs.url
}