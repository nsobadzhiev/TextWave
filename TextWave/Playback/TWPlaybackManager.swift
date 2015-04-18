//
//  TWPlaybackManager.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/22/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import AVFoundation

// MARK: Notification names

let TWPlaybackStartedNotification = "TWPlaybackStartedNotification"
let TWPlaybackEndedNotification = "TWPlaynackEndedNotification"
let TWPlaybackChangedNotification = "TWPlaybackChangedNotification"

protocol TWPlaybackManagerDelegate {
    func playbackManager(playback: TWPlaybackManager, didBeginItemAtIndex index: Int)
    func playbackManager(playback: TWPlaybackManager, didFinishItemAtIndex index: Int)
    func playbackManager(playback: TWPlaybackManager, didMoveToPosition index: Int)
}

class TWPlaybackManager : NSObject, AVSpeechSynthesizerDelegate {
    
    var textToSpeech = AVSpeechSynthesizer()
    var playbackSource: TWPlaybackSource? = nil
    var speechRate: Float = 0.15
    var speechPitch: Float = 0.0
    var wordIndex = 0
    var letterIndex = 0
    var delegate: TWPlaybackManagerDelegate? = nil
    
    var isPlaying: Bool {
        get {
            return textToSpeech.speaking && !textToSpeech.paused
        }
    }
    
    var currentText: String? {
        get {
            return self.playbackSource?.currentText
        }
    }

    init(dataSource: TWPlaybackSource) {
        super.init()
        self.playbackSource = dataSource
        textToSpeech.delegate = self
    }
    
    deinit {
        self.finish()
    }
    
    func pause() {
        textToSpeech.pauseSpeakingAtBoundary(AVSpeechBoundary.Word)
    }
    
    func resume() {
        let speakingContinued = textToSpeech.continueSpeaking()
        if speakingContinued == false {
            self.next()
        }
    }
    
    func stop() {
        textToSpeech.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    func start() {
        textToSpeech.delegate = self
        self.next()
    }
    
    func finish() {
        textToSpeech.delegate = nil
        textToSpeech.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    func previous() {
        self.playbackSource!.goToPreviousItem()
        if let speechText = self.playbackSource?.currentText {
            self.speakText(speechText)
        }
    }
    
    func next() {
        if self.playbackSource?.goToNextItem() != false {
            if let speechText = self.playbackSource?.currentText {
                self.speakText(speechText)
                self.postChangedNotification()
                if self.playbackSource?.currentItemIndex == 0 {
                    // this means that this is the first time playback starts
                    // post "started" notification
                    self.postStartedNotification()
                }
            }
        }
        else {
            self.postEndedNotification()
        }
    }
    
    func skipForward() {
        if let textAfterSkip = self.textAfterSkippingCharacters(30) {
            self.speakText(textAfterSkip)
            self.postChangedNotification()
        }
        else {
            self.next()
        }
    }
    
    func skipBackwards() {
        let textAfterSkip = self.textAfterSkippingCharacters(-30)
        if (textAfterSkip?.isEmpty == false) {
            self.speakText(textAfterSkip!)
            self.postChangedNotification()
        }
        else {
            self.previous()
        }
    }
    
    func setPlaybackProgress(progressPercentage: Float) {
        if (progressPercentage > 1.0 || progressPercentage < 0.0) {
            return;
        }
        
        if let currentTextLength: Int = self.playbackSource?.currentText?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
            let indexAfterSkip = Float(currentTextLength) * progressPercentage
            let text:String! = self.playbackSource?.currentText!
            let index = advance(text.startIndex, Int(indexAfterSkip))
            let textAfterSkip = self.playbackSource!.currentText!.substringFromIndex(index)
            self.speakText(textAfterSkip)
            self.postChangedNotification()
        }
    }
    
    func speakText(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = self.speechRate
        utterance.pitchMultiplier = self.speechPitch
        textToSpeech.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        textToSpeech.speakUtterance(utterance)
    }
    
    // MARK: Notifications
    
    func postChangedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(TWPlaybackChangedNotification, object: self)
    }
    
    func postEndedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(TWPlaybackEndedNotification, object: self)
    }
    
    func postStartedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(TWPlaybackStartedNotification, object: self)
    }
    
    /** 
    * speechSynthesizerPitchForValue is designed to map a normalized pitch value
    * (0.0 to 1.0) to AVSpeechSynthesizer's pitchMultiplier property values 
    * (0.5 to 2.0)
    */
    
    func speechSynthesizerPitchForValue(normalizedValue: Float) -> Float {
        let pitchMultiplierMin: Float = 0.5
        let pitchMultiplierMax: Float = 2.0
        let pitchMultiplierRange: Float = pitchMultiplierMax - pitchMultiplierMin
        let absoluteNormalizedValue: Float = fabsf(normalizedValue)
        let normalizedSpeechPitch: Float = min(1.0, absoluteNormalizedValue)
        return normalizedSpeechPitch / pitchMultiplierRange
    }
    
    func textAfterSkippingCharacters(numCharacters: Int) -> String? {
        if self.letterIndex + numCharacters < self.playbackSource!.currentText?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) && self.letterIndex as Int + numCharacters >= 0 {
            self.letterIndex += numCharacters
            let text: String = self.playbackSource!.currentText!
            let index = advance(text.startIndex, Int(self.letterIndex))
            let textAfterSkip = self.playbackSource!.currentText!.substringFromIndex(index)
            if (Array(text)[self.letterIndex - 1] == " " ||
                Array(text)[self.letterIndex] == " ") {
                    return textAfterSkip
                }
                else {
                let firstSpaceRange = textAfterSkip.rangeOfString(" ")
                let spaceRangeStart: String.Index! = firstSpaceRange?.startIndex
                var indexInt: Int = distance(textAfterSkip.startIndex, spaceRangeStart)
                let index = advance(textAfterSkip.startIndex, indexInt)
                    if firstSpaceRange != nil {
                        return textAfterSkip.substringFromIndex(index)
                    }
                }
            }
        return nil
    }

// AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance: AVSpeechUtterance!) {
        if let beginIndex = self.playbackSource?.currentItemIndex {
            self.delegate?.playbackManager(self, didBeginItemAtIndex: beginIndex)
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        if let finishIndex = self.playbackSource?.currentItemIndex {
            self.delegate?.playbackManager(self, didFinishItemAtIndex: finishIndex)
        }
        // continue with the next one if available
        self.next()
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!,
        didPauseSpeechUtterance utterance: AVSpeechUtterance!) {
            
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!,
        didCancelSpeechUtterance utterance: AVSpeechUtterance!) {
            
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        self.wordIndex += 1
        self.letterIndex = characterRange.location + characterRange.length
        if let existingDelegate = self.delegate {
            self.delegate!.playbackManager(self, didMoveToPosition: self.wordIndex)
        }
    }

}