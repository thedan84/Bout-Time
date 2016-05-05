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
    var timer = NSTimer()
    var seconds = 60
    
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
        if round != 6 {
            nextRoundButton.hidden = true
            startNewRound()
        } else {
            let resultVC = storyboard?.instantiateViewControllerWithIdentifier("ResultVC") as! ResultViewController
            resultVC.score = points
            presentViewController(resultVC, animated: true) {
                self.startNewGame()
                self.nextRoundButton.hidden = true
            }
        }
    }
    
    //MARK: - UIEvent
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        switch motion {
        case .MotionShake:
            validateAnswer()
        default: break
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
        startTimer()
    }
    
    func startNewRound() {
        factManager.facts = []
        self.factManager.getRandomFacts()
        
        reloadData()
        
        timerLabel.text = "1:00"
        round += 1
        startTimer()
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
    
    func startTimer() {
        self.seconds = 60
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.timerFire(_:)), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    func timerFire(timer: NSTimer) {
        self.seconds -= 1
        timerLabel.text = "\(seconds)"
        if seconds == 0 {
            validateAnswer()
        }
    }
    
    func validateAnswer() {
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
        
        stopTimer()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
}