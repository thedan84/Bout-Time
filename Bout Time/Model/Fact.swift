//
//  Fact.swift
//  Bout Time
//
//  Created by Dennis Parussini on 03-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

// Struct to model the logic of a 'historical' fact
struct Fact: Codable, Equatable {
    var name: String
    var year: Int
    var url: String
}
