//
//  ViewController.swift
//  Bout Time
//
//  Created by Dennis Parussini on 02-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var fact = Fact()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let f = self.fact.getRandomFact()
        print(f)
    }
}

