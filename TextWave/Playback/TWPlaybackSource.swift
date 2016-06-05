//
//  TWPlaybackSource.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/22/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWPlaybackSourceDelegate {
    func playbackSourceDidLoadResources(playbackSource: TWPlaybackSource)
    func playbackSource(playbackSource: TWPlaybackSource, didFailWithError error: NSError?)
}

class TWPlaybackSource {
    var sourceURL: NSURL? = nil
    var currentText: String? = nil
    var currentItemIndex = -1
    var title: String? = nil
    var subtitle: String? = nil
    var delegate: TWPlaybackSourceDelegate? = nil
    
    var numberOfItems: Int {
        get {
            return 0
        }
    }

    init(url: NSURL?) {
        self.sourceURL = url
    }
    
    // prepareResources is intended for making sure all data needed for playback
    // is available. Subclasses should override this method adn load all resources
    func prepareResources() {
    
    }
    
    func goToNextItem() -> Bool {
        self.currentItemIndex += 1
        return false
    }
    
    func goToPreviousItem() {
        if (self.currentItemIndex > 0) {
            self.currentItemIndex -= 1
        }
    }
    
    func goToItemAtIndex(index: Int) {
        
    }
}