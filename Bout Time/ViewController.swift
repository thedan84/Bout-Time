//
//  ViewController.swift
//  Bout Time
//
//  Created by Dennis Parussini on 02-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit
import AudioToolbox

enum NextRoundImage: String {
    case Success = "next_round_success.png"
    case Failure = "next_round_fail.png"
    
    func imageName() -> UIImage {
        return UIImage(named: self.rawValue)!
    }
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
    
    //MARK: - Properties
    var factManager = FactManager()
    var round = 1
    var points = 0
    var sound = Sound()
    
    //MARK: - View lifecycle
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        startNewGame()
    }
    
    //MARK: - IBActions
    @IBAction func downButtonTapped(sender: UIButton) {
        let oldIndex = sender.tag - 1
        let newIndex = sender.tag
        
        factManager.swapTwoFacts(oldIndex, newIndex)

        reloadData()
    }
    
    @IBAction func upButtonTapped(sender: UIButton) {
        let oldIndex = sender.tag - 1
        let newIndex = sender.tag - 2
        
        factManager.swapTwoFacts(oldIndex, newIndex)
        
        reloadData()
    }
    
    @IBAction func nextRoundButtonTapped(sender: UIButton) {
        nextRoundButton.hidden = true
        startNewRound()
    }
    
    //MARK: - UIEvent
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if round != 6 {
            switch motion {
            case .MotionShake:
                let result = self.factManager.checkRightOrderOfFacts(self.factManager.facts)
                
                switch result {
                case true:
                    sound.playRightAnswerSound()
                    nextRoundButton.setImage(NextRoundImage.Success.imageName(), forState: .Normal)
                    nextRoundButton.hidden = false
                    points += 1
                case false:
                    sound.playWrongAnswerSound()
                    nextRoundButton.setImage(NextRoundImage.Failure.imageName(), forState: .Normal)
                    nextRoundButton.hidden = false
                }
            default: break
            }
        } else {
            let resultVC = storyboard?.instantiateViewControllerWithIdentifier("ResultVC") as! ResultViewController
            resultVC.score = points
            presentViewController(resultVC, animated: true) {
                self.startNewGame()
            }
        }
    }
    
    //MARK: - Helper methods
    func setupViews() {
        let views = [view1, view2, view3, view4]
        
        for view in views {
            view.layer.cornerRadius = view.bounds.width / 50
        }
    }
    
    func startNewGame() {
        factManager.facts = []
        self.factManager.getRandomFacts()

        reloadData()
        
        timerLabel.text = "1:00"
        round = 1
        points = 0
    }
    
    func startNewRound() {
        factManager.facts = []
        self.factManager.getRandomFacts()
        
        reloadData()
        
        timerLabel.text = "1:00"
        round += 1
    }
    
    func reloadData() {
        let labels = [factLabel1, factLabel2, factLabel3, factLabel4]
        
        for index in 0..<factManager.facts.count {
            let label = labels[index]
            if let text = factManager.facts[index].fact {
                label.text = text
            }
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
}