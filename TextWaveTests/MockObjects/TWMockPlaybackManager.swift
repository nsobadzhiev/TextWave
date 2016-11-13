//
//  TWMockPlaybackManager.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/22/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import AVFoundation

class TWMockPlaybackManager : TWPlaybackManager {

    var wasAskedToPlay = false
    var wasAskedToPlayNext = false
    var wasAskedToStop = false
    var wasAskedToPlayPrevious = false
    var wasAskedToSkipForward = false
    var wasAskedToSkipBackwards = false
    var setPlaybackProgress: Float = 0.0
        
    var speechSynthesizer: AVSpeechSynthesizer! {
    get {
        return super.textToSpeech
    }
    set {
        newValue.delegate = super.textToSpeech.delegate
        super.textToSpeech = newValue
    }
    }
    
    override func pause() {
        super.pause()
        self.wasAskedToStop = true
    }
    
    override func resume() {
        super.resume()
        self.wasAskedToPlay = true
    }
    
    override func previous() {
        super.previous()
        self.wasAskedToPlayPrevious = true
    }
    
    override func next() {
        super.next()
        self.wasAskedToPlayNext = true
    }
    
    override func skipForward() {
        super.skipForward()
        self.wasAskedToSkipForward = true
    }
    
    override func skipBackwards() {
        super.skipBackwards()
        self.wasAskedToSkipBackwards = true
    }
    
    override func setPlaybackProgress(_ progressPercentage: Float) {
        super.setPlaybackProgress(progressPercentage)
        self.setPlaybackProgress = progressPercentage;
    }

}
