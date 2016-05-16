//
//  TWPlaybackConfiguration.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 5/12/16.
//  Copyright © 2016 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import AVFoundation

let TWPlaybackConfigurationChangeNotification = "TWPlaybackConfigurationChangeNotification"

class TWPlaybackConfiguration {
    var speechRate: Float = 0.35 {
        didSet {
            self.postChangeNotification()
        }
    }
    var speechPitch: Float = 0.0 {
        didSet {
            self.postChangeNotification()
        }
    }
    
    let minRate = AVSpeechUtteranceMinimumSpeechRate
    let maxRate = AVSpeechUtteranceMaximumSpeechRate
    let minPitch:Float = 0.5
    let maxPitch:Float = 2.0  // both according to the spec
    
    static let defaultConfiguration = TWPlaybackConfiguration()
    
    func postChangeNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(TWPlaybackConfigurationChangeNotification, object: nil)
    }
}