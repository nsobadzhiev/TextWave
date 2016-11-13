//
//  TWMockSpeechSynthesizer.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/1/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import AVFoundation

class TWMockSpeechSynthesizer : AVSpeechSynthesizer {
    var hasAskedToPause = false
    var hasAskedToResume = false
    var hasAskedToStopPlayback = false
    var suppliedUtterance: AVSpeechUtterance? = nil
    
    override func pauseSpeaking(at boundary: AVSpeechBoundary) -> Bool {
        self.hasAskedToPause = true
        return true
    }
    
    override func continueSpeaking() -> Bool {
        self.hasAskedToResume = true
        return true
    }
        
    override func speak(_ utterance: AVSpeechUtterance!) {
        self.suppliedUtterance = utterance;
    }
    
    override func stopSpeaking(at boundary: AVSpeechBoundary) -> Bool {
        self.hasAskedToStopPlayback = true
        return true
    }
}
