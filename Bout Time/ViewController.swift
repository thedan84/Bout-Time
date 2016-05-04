//
//  ViewController.swift
//  Bout Time
//
//  Created by Dennis Parussini on 02-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit

enum NextRoundImages: String {
    case Success = "next_round_success.png"
    case Failure = "next_round_fail.png"
    case PlayAgain = "play_again.png"
}

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var factLabel1: UILabel!
    @IBOutlet weak var factLabel2: UILabel!
    @IBOutlet weak var factLabel3: UILabel!
    @IBOutlet weak var factLabel4: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var nextRoundButton: UIButton!
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupGame()
    }
    
    //MARK: - IBActions
    @IBAction func downButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func upButtonTapped(sender: UIButton) {
        
    }
    
    @IBAction func nextRoundButtonTapped(sender: UIButton) {
        
    }
    
    
    //MARK: - Helper methods
    func setupViews() {
        let views = [view1, view2, view3, view4]
        
        for view in views {
            view.layer.cornerRadius = view.bounds.width / 50
        }
    }
    
    func setupGame() {
        timerLabel.text = "1:00"
    }
}