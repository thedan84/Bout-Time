//
//  PlistConverterType.swift
//  Bout Time
//
//  Created by Dennis Parussini on 02-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

// Protocol to which the type has to conform to get Facts out of the Facts.plist
protocol PlistConverterType {
    func convertPlistToArray(plist: String) -> [[String: AnyObject]]?
}

// Extension which converts the plist to the desired Facts array
extension PlistConverterType {
    func convertPlistToArray(plist: String) -> [[String: AnyObject]]? {
        
        guard let path = NSBundle.mainBundle().pathForResource(plist, ofType: "plist"), let array = NSArray(contentsOfFile: path) as? [[String: AnyObject]] else { return nil }
                
        return array
    }
}