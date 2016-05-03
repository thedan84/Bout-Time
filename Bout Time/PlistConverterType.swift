//
//  PlistConverterType.swift
//  Bout Time
//
//  Created by Dennis Parussini on 02-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation

protocol PlistConverterType {
    func convertPlistToArray(plist: String) -> [[String: AnyObject]]?
}

extension PlistConverterType {
    func convertPlistToArray(plist: String) -> [[String: AnyObject]]? {
        
        guard let path = NSBundle.mainBundle().pathForResource(plist, ofType: "plist"), let array = NSArray(contentsOfFile: path) as? [[String: AnyObject]] else { return nil }
                
        return array
    }
}