//
//  ViewController.swift
//  Bout Time
//
//  Created by Dennis Parussini on 02-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit
import AudioToolbox
import SafariServices

// Enum to provide the right image to the 'nextRoundButton'
enum NextRoundImage: String {
    case Success = "next_round_success.png"
    case Failure = "next_round_fail.png"
    
    func imageName() -> UIImage {
        return UIImage(named: self.rawValue)!
    }
}

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
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
    
    @IBOutlet weak var roundLabel: UILabel!
    
    //MARK: - Properties
    var factManager = FactManager()
    var round: Int = 1 {
        didSet {
            self.roundLabel.text = "\(round)"
        }
    }
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
        roundLabel.text = "\(round)"
    }
    
    //MARK: - IBActions
    // Moves the selected fact one position down
    @IBAction func downButtonTapped(sender: UIButton) {
        let oldIndex = sender.tag - 1
        let newIndex = sender.tag
        
        factManager.swapTwoFacts(oldIndex, newIndex)

        reloadData()
    }
    
    // Moves the selected fact one position up
    @IBAction func upButtonTapped(sender: UIButton) {
        let oldIndex = sender.tag - 1
        let newIndex = sender.tag - 2
        
        factManager.swapTwoFacts(oldIndex, newIndex)
        
        reloadData()
    }
    
    // Starts a new play round
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
    // Shake gesture to validate the answer
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        switch motion {
        case .MotionShake:
            validateAnswer()
        default: break
        }
    }
    
    //MARK: - Helper methods
    // Adds a corner radius to the fact views
    func setupViews() {
        let views = [view1, view2, view3, view4]
        
        for view in views {
            view.layer.cornerRadius = view.bounds.width / 50
        }
    }
    
    // Starts a new game
    func startNewGame() {
        factManager.facts = []
        self.factManager.getRandomFacts()

        reloadData()
        
        timerLabel.text = "1:00"
        round = 1
        points = 0
        startTimer()
        disableLabels()
    }
    
    // Starts a new round
    func startNewRound() {
        factManager.facts = []
        self.factManager.getRandomFacts()
        
        reloadData()
        
        timerLabel.text = "1:00"
        round += 1
        startTimer()
        disableLabels()
    }
    
    // Reloads the labels after a fact has been moved
    func reloadData() {
        let labels = [factLabel1, factLabel2, factLabel3, factLabel4]
        
        for index in 0..<factManager.facts.count {
            let label = labels[index]
            if let text = factManager.facts[index].fact {
                label.text = text
            }
        }
    }
    
    // Starts the timer
    func startTimer() {
        self.seconds = 60
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.timerFire(_:)), userInfo: nil, repeats: true)
    }
    
    // Stops the timer
    func stopTimer() {
        self.timer.invalidate()
    }
    
    // Helper method for the round timer
    func timerFire(timer: NSTimer) {
        self.seconds -= 1
        timerLabel.text = "\(seconds)"
        if seconds == 0 {
            validateAnswer()
        }
    }
    
    // Validates the answer with the help of the helper method declared in 'FactManager'
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
        
        let labels = [factLabel1, factLabel2, factLabel3, factLabel4]
        
        for label in labels {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.factTapped(_:)))
            label.addGestureRecognizer(gestureRecognizer)
            label.userInteractionEnabled = true
        }
        
    }
    
    // Opens the Safari View Controller after the user tapped on a facg
    func factTapped(sender: UITapGestureRecognizer) {
        let fact = factManager.facts[sender.view!.tag - 1]
        if let urlString = fact.url, let url = NSURL(string: urlString) {
            let safariVC = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            safariVC.delegate = self
            presentViewController(safariVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - SafariViewControllerDelegate
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Disables the labels while the round is being played
    func disableLabels() {
        let labels = [factLabel1, factLabel2, factLabel3, factLabel4]
        
        for label in labels {
            label.userInteractionEnabled = false
        }
    }
    
    // Helper method for the shake gesture
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
}