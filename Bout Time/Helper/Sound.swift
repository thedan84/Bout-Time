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
    //MARK: - System Sounds
    private static let rightAnswerSound: SystemSoundID = {
        //Force unwrapping here because the sound file is bundled with the app
        let pathToSoundFile = Bundle.main.url(forResource: "CorrectDing", withExtension: "wav")!
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(pathToSoundFile as CFURL, &soundID)
        return soundID
    }()
    
    private static let wrongAnswerSound: SystemSoundID = {
        //Force unwrapping here because the sound file is bundled with the app
        let pathToSoundFile = Bundle.main.url(forResource: "IncorrectBuzz", withExtension: "wav")!
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(pathToSoundFile as CFURL, &soundID)
        return soundID
    }()
    
    //MARK: - Private Initializer - Don't allow any initialization outside of this type
    private init() {}
    
    //MARK: - Play sound functions
    static func playRightAnswerSound() {
        AudioServicesPlaySystemSound(rightAnswerSound)
    }
    
    static func playWrongAnswerSound() {
        AudioServicesPlaySystemSound(wrongAnswerSound)
    }

}
