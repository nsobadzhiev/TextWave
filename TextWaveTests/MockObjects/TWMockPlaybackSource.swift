//
//  TWMockPlaybackSource.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/22/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWMockPlaybackSource : TWPlaybackSource {
    var hasAskedPreviousSection = false
    var hasAskedNextSection = false
    var currentHardcodedText: String? = nil
    var previousSpeechString: String? = nil
    var nextSpeechString: String? = nil
    
    override init(url: URL?) {
        super.init(url: url)
    }
    
    override func goToNextItem() {
        self.hasAskedNextSection = true;
        if (self.nextSpeechString?.isEmpty == false) {
            self.currentText = self.nextSpeechString;
        }
        else {
            super.goToNextItem()
        }
    }
    
    override func goToPreviousItem() {
        self.hasAskedPreviousSection = true;
        if (self.previousSpeechString?.isEmpty == false) {
            self.currentText = self.previousSpeechString;
        }
        else {
            super.goToPreviousItem()
        }
    }
}
