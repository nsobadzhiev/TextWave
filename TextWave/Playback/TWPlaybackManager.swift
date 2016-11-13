//
//  TWPlaybackManager.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/22/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import AVFoundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


// MARK: Notification names

let TWPlaybackStartedNotification = "TWPlaybackStartedNotification"
let TWPlaybackEndedNotification = "TWPlaynackEndedNotification"
let TWPlaybackChangedNotification = "TWPlaybackChangedNotification"

protocol TWPlaybackManagerDelegate : class {
    func playbackManager(_ playback: TWPlaybackManager, didBeginItemAtIndex index: Int)
    func playbackManager(_ playback: TWPlaybackManager, didFinishItemAtIndex index: Int)
    func playbackManager(_ playback: TWPlaybackManager, didMoveToPosition index: Int)
}

class TWPlaybackManager : NSObject, AVSpeechSynthesizerDelegate {
    
    var textToSpeech = AVSpeechSynthesizer()
    var playbackSource: TWPlaybackSource? = nil
    var wordIndex = 0
    var letterIndex = 0
    weak var delegate: TWPlaybackManagerDelegate? = nil
    
    var isPlaying: Bool {
        get {
            return textToSpeech.isSpeaking && !textToSpeech.isPaused
        }
    }
    
    var currentText: String? = nil

    init(dataSource: TWPlaybackSource) {
        super.init()
        self.playbackSource = dataSource
        textToSpeech.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onPlaybackConfigurationChange), name: NSNotification.Name(rawValue: TWPlaybackConfigurationChangeNotification), object: nil)
    }
    
    deinit {
        self.finish()
    }
    
    func pause() {
        textToSpeech.pauseSpeaking(at: AVSpeechBoundary.word)
    }
    
    func resume() {
        let speakingContinued = textToSpeech.continueSpeaking()
        if speakingContinued == false {
            self.next()
        }
    }
    
    func stop() {
        textToSpeech.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    func start() {
        textToSpeech.delegate = self
        self.next()
    }
    
    func finish() {
        textToSpeech.delegate = nil
        textToSpeech.stopSpeaking(at: AVSpeechBoundary.immediate)
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
    
    func setPlaybackProgress(_ progressPercentage: Float) {
        if (progressPercentage > 1.0 || progressPercentage < 0.0) {
            return;
        }
        
        if let currentTextLength: Int = self.currentText?.lengthOfBytes(using: String.Encoding.utf8) {
            let indexAfterSkip = Float(currentTextLength) * progressPercentage
            // TODO: excessive use of !
            let text:String! = self.currentText!
            let index = text.index(text.startIndex, offsetBy: Int(indexAfterSkip))
            let textAfterSkip = self.currentText!.substring(from: index)
            self.speakText(textAfterSkip)
            self.postChangedNotification()
        }
    }
    
    func speakText(_ text: String) {
        self.currentText = text
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = TWPlaybackConfiguration.defaultConfiguration.speechRate
        utterance.pitchMultiplier = TWPlaybackConfiguration.defaultConfiguration.speechPitch
        textToSpeech.stopSpeaking(at: AVSpeechBoundary.immediate)
        textToSpeech.speak(utterance)
    }
    
    // MARK: Notifications
    
    func postChangedNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: TWPlaybackChangedNotification), object: self)
    }
    
    func postEndedNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: TWPlaybackEndedNotification), object: self)
    }
    
    func postStartedNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: TWPlaybackStartedNotification), object: self)
    }
    
    /** 
    * speechSynthesizerPitchForValue is designed to map a normalized pitch value
    * (0.0 to 1.0) to AVSpeechSynthesizer's pitchMultiplier property values 
    * (0.5 to 2.0)
    */
    
    func speechSynthesizerPitchForValue(_ normalizedValue: Float) -> Float {
        let pitchMultiplierMin: Float = 0.5
        let pitchMultiplierMax: Float = 2.0
        let pitchMultiplierRange: Float = pitchMultiplierMax - pitchMultiplierMin
        let absoluteNormalizedValue: Float = fabsf(normalizedValue)
        let normalizedSpeechPitch: Float = min(1.0, absoluteNormalizedValue)
        return normalizedSpeechPitch / pitchMultiplierRange
    }
    
    func textAfterSkippingCharacters(_ numCharacters: Int) -> String? {
        if self.letterIndex + numCharacters < self.currentText?.lengthOfBytes(using: String.Encoding.utf8) && self.letterIndex as Int + numCharacters >= 0 {
            self.letterIndex += numCharacters
            // TODO: excessive use of !
            let text: String = self.currentText!
            let index = text.characters.index(text.startIndex, offsetBy: Int(self.letterIndex))
            let textAfterSkip = self.currentText!.substring(from: index)
            let prevSymbol = text[text.characters.index(text.startIndex, offsetBy: self.letterIndex - 1)];
            let firstSymbol = text[text.characters.index(text.startIndex, offsetBy: self.letterIndex)];
            self.letterIndex = 0    // restart the counting since the speach text has changed and the
            // new index is zero (the new string is going to start at the)
            // correct index
            if (prevSymbol == " " || firstSymbol == " ") {
                return textAfterSkip
            }
            else {
                let firstSpaceRange = textAfterSkip.range(of: " ")
                let spaceRangeStart: String.Index! = firstSpaceRange?.lowerBound
                let indexInt: Int = textAfterSkip.characters.distance(from: textAfterSkip.startIndex, to: spaceRangeStart)
                let index = textAfterSkip.characters.index(textAfterSkip.startIndex, offsetBy: indexInt)
                if firstSpaceRange != nil {
                    return textAfterSkip.substring(from: index)
                }
            }
        }
        return nil
    }

// AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        if let beginIndex = self.playbackSource?.currentItemIndex {
            self.delegate?.playbackManager(self, didBeginItemAtIndex: beginIndex)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if let finishIndex = self.playbackSource?.currentItemIndex {
            self.delegate?.playbackManager(self, didFinishItemAtIndex: finishIndex)
        }
        // continue with the next one if available
        self.next()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
        didPause utterance: AVSpeechUtterance) {
            
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance) {
            
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        self.wordIndex += 1
        self.letterIndex = characterRange.location + characterRange.length
        if let existingDelegate = self.delegate {
            existingDelegate.playbackManager(self, didMoveToPosition: self.wordIndex)
        }
    }
    
    // MARK: NSNotification
    
    func onPlaybackConfigurationChange () {
        // restart the current text
        if let text = self.currentText {
            self.speakText(text)
        }
    }

}
