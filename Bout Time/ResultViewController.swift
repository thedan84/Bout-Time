//
//  ResultViewController.swift
//  Bout Time
//
//  Created by Dennis Parussini on 05-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit

final class ResultViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: - Properties
    var score = Int()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let result = score * 100 / 6
        resultLabel.text = "\(result) %"
    }
    
    // MARK: - Action methods
    // Function to play another round
    @IBAction func playAgainButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
