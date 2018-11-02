//
//  PlistConverterType.swift
//  Bout Time
//
//  Created by Dennis Parussini on 02-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

// Protocol to which the type has to conform to get Facts out of the Facts.plist
protocol PlistConverter {
    static func convertPlistToArray(_ plist: String, with decoder: PropertyListDecoder) -> [Fact]?
}

// Extension which converts the plist to the desired Facts array
extension PlistConverter {
    static func convertPlistToArray(_ plist: String, with decoder: PropertyListDecoder = PropertyListDecoder()) -> [Fact]? {
        
        guard let url = Bundle.main.url(forResource: plist, withExtension: "plist"), let data = try? Data(contentsOf: url) else { return nil }
        
        do {
            let facts = try decoder.decode([Fact].self, from: data)
            return facts
        } catch {
            print(error)
        }
        
        return nil
    }
}
