//
//  ViewController.swift
//  Bout Time
//
//  Created by Dennis Parussini on 02-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import UIKit
import SafariServices

final class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var views: [UIView]!
    @IBOutlet var factLabels: [UILabel]!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var nextRoundButton: UIButton!
    
    @IBOutlet weak var roundLabel: UILabel!
    
    // Property with setter to update the roundLabel's text
    var round: Int = 1 {
        didSet {
            self.roundLabel.text = "\(round)"
        }
    }
    
    var points = 0
    var timer = Timer()
    var seconds = 60
    
    //Enable the view controller to become the first responder. Needed for the shake gesture
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - View lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        startRound(isNewGame: true)
        roundLabel.text = "\(round)"
    }
    
    //MARK: - UIEvent
    // Shake gesture to validate the answer
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if case .motionShake = motion {
            validateAnswer()
        }
    }
    
    //MARK: - Helper methods
    // Adds a corner radius to the fact views
    func setupViews() {
        views.forEach { $0.layer.cornerRadius = $0.bounds.width / 50 }
    }
    
    // Starts a new game
    func startRound(isNewGame: Bool = false) {
        FactManager.facts = []
        FactManager.getRandomFacts()
        
        reloadData()
        
        timerLabel.text = "1:00"
        startTimer()
        disableLabels()
        
        if isNewGame {
            round = 1
            points = 0
        } else {
            round += 1
        }
    }
    
    // Reloads the labels after a fact has been moved
    func reloadData() {
        for (index, fact) in FactManager.facts.enumerated() {
            factLabels[index].text = fact.name
        }
    }
    
    // Starts the timer
    func startTimer() {
        self.seconds = 60
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    // Stops the timer
    func stopTimer() {
        self.timer.invalidate()
    }
    
    // Helper method for the round timer
    @objc func timerFired(_ timer: Timer) {
        self.seconds -= 1
        timerLabel.text = "\(seconds)"
        if seconds == 0 {
            validateAnswer()
        }
    }
    
    // Validates the answer with the help of the helper method declared in 'FactManager'
    func validateAnswer() {
        let result = FactManager.checkRightOrderOfFacts(FactManager.facts)
        
        switch result {
        case true:
            Sound.playRightAnswerSound()
            nextRoundButton.setImage(UIImage(named: .success), for: UIControl.State())
            nextRoundButton.isHidden = false
            points += 1
        case false:
            Sound.playWrongAnswerSound()
            nextRoundButton.setImage(UIImage(named: .failure), for: UIControl.State())
            nextRoundButton.isHidden = false
        }
        
        stopTimer()
        
        factLabels.forEach {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(factTapped))
            $0.addGestureRecognizer(gestureRecognizer)
            $0.isUserInteractionEnabled = true
        }
    }
    
    // Opens the Safari View Controller after the user tapped on a fact
    @objc func factTapped(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        if let url = FactManager.getURLForFact(FactManager.facts[tag - 1]) {
            let safariVC = SFSafariViewController(url: url)
            safariVC.delegate = self
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    // Disables the labels while the round is being played
    func disableLabels() {
        factLabels.forEach { $0.isUserInteractionEnabled = false }
    }
    
    //MARK: - IBActions
    // Moves the selected fact one position down
    @IBAction func downButtonTapped(_ sender: UIButton) {
        let oldIndex = sender.tag - 1
        let newIndex = sender.tag
        
        FactManager.swapTwoFacts(oldIndex, newIndex)

        reloadData()
    }
    
    // Moves the selected fact one position up
    @IBAction func upButtonTapped(_ sender: UIButton) {
        let oldIndex = sender.tag - 1
        let newIndex = sender.tag - 2
        
        FactManager.swapTwoFacts(oldIndex, newIndex)
        
        reloadData()
    }
    
    // Starts a new play round
    @IBAction func nextRoundButtonTapped(_ sender: UIButton) {
        if round != 6 {
            nextRoundButton.isHidden = true
            startRound()
        } else {
            guard let resultVC = storyboard?.instantiateViewController(withIdentifier: "ResultVC") as? ResultViewController else { return }
            resultVC.score = points
            present(resultVC, animated: true) { [unowned self] in
                self.startRound(isNewGame: true)
                self.nextRoundButton.isHidden = true
            }
        }
    }
}

// MARK: - SafariViewControllerDelegate
extension ViewController: SFSafariViewControllerDelegate {    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
}
