//
//  ResultViewController.swift
//  Bout Time
//
//  Created by Dennis Parussini on 05-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var score = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let result = score * 100 / 6
        resultLabel.text = "\(result) %"
    }
    
    @IBAction func playAgainButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
