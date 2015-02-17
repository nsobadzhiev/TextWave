//
//  TWNowPlayingManager.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/5/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

let sharedInstance = TWNowPlayingManager()

class TWNowPlayingManager {
    
    let playbackSourcesDict = [TWFileType.EPUB: createEpubPlaybackSource, TWFileType.HTML: createHtmlPlaybackSource]

    class var instance: TWNowPlayingManager {
        return sharedInstance
    }
    
    let lockScreenInfo: TWLockScreenNowPlayingInfo = TWLockScreenNowPlayingInfo()
    var selectedItem: String? = nil
    
    var playbackManager: TWPlaybackManager? = nil {
        didSet {
            self.lockScreenInfo.playbackManager = self.playbackManager
        }
    }
    
    func startPlaybackWithUrl(url: NSURL?) {
        let source = self.playbackSourceForUrl(url)
        if let source = source {
            self.playbackManager = TWPlaybackManager(dataSource: source)
        }
    }
    
    func startPlaybackWithUrl(url: NSURL?, selectedItem: NSString?) {
        let source = self.playbackSourceForUrl(url)
        if let source = source {
            self.playbackManager?.finish()
            self.playbackManager = TWPlaybackManager(dataSource: source)
            self.selectedItem = selectedItem
        }
    }
    
    func playbackSourceForUrl(url:NSURL?) -> TWPlaybackSource? {
        let fileType = TWFileTypeManager.fileType(fileUrl: url)
        let playbackSourceGeneratorFunction = self.playbackSourcesDict[fileType]
        if let playbackSourceGeneratorFunction = playbackSourceGeneratorFunction {
            return playbackSourceGeneratorFunction(self)(sourceUrl: url)
        }
        return nil
    }
    
    func createEpubPlaybackSource(#sourceUrl:NSURL?) -> TWPlaybackSource {
        let epubPlaybackSource = TWEpubPlaybackSource(url: sourceUrl)
        if self.selectedItem != nil {
            epubPlaybackSource.goToItemWithPath(self.selectedItem)
        }
        return epubPlaybackSource
    }
    
    func createHtmlPlaybackSource(#sourceUrl:NSURL?) -> TWPlaybackSource {
        return TWHtmlPlaybackSource(url: sourceUrl)
    }
}