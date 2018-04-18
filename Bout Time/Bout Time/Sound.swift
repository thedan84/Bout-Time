//
//  Sound.swift
//  Bout Time
//
//  Created by Dennis Parussini on 05-05-16.
//  Copyright © 2016 Dennis Parussini. All rights reserved.
//

import Foundation
import AudioToolbox

struct Sound {
    
    //MARK: - Properties
    var rightAnswerSound: SystemSoundID = 0
    var wrongAnswerSound: SystemSoundID = 1
    
    //Properties which get the right sound based on path
    var rightSound: NSURL {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("CorrectDing", ofType: "wav")
        return NSURL(fileURLWithPath: pathToSoundFile!)
    }
    
    var wrongSound: NSURL {
        let pathToSoundFile = NSBundle.mainBundle().pathForResource("IncorrectBuzz", ofType: "wav")
        return NSURL(fileURLWithPath: pathToSoundFile!)
    }
    
    //Helper function to load the right sound from the bundle url
    mutating func loadSoundWithURL(url: NSURL, inout id: SystemSoundID) {
        AudioServicesCreateSystemSoundID(url, &id)
    }
    
    //MARK: - Play the right sound
    mutating func playRightAnswerSound() {
        loadSoundWithURL(rightSound, id: &rightAnswerSound)
        AudioServicesPlaySystemSound(rightAnswerSound)
    }
    
    mutating func playWrongAnswerSound() {
        loadSoundWithURL(wrongSound, id: &wrongAnswerSound)
        AudioServicesPlaySystemSound(wrongAnswerSound)
    }
}