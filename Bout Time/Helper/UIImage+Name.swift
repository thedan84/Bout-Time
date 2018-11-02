//
//  UIImage+Name.swift
//  Bout Time
//
//  Created by Dennis Parussini on 02.11.18.
//  Copyright © 2018 Dennis Parussini. All rights reserved.
//

import UIKit

extension UIImage {
    struct Name: RawRepresentable {
        typealias RawValue = String
        
        var rawValue: RawValue
        var name: String { return rawValue }
        
        init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
        
        init(name: String) {
            self.init(rawValue: name)
        }
    }
    
    convenience init?(named: Name) {
        self.init(named: named.name)
    }
}

extension UIImage.Name {
    static let success = UIImage.Name(name: "next_round_success.png")
    static let failure = UIImage.Name(name: "next_round_fail.png")
}
