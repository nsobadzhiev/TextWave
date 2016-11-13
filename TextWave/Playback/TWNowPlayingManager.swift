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
    
    let playbackSourcesDict = [TWFileType.epub: createEpubPlaybackSource, TWFileType.html: createHtmlPlaybackSource]

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
    
    var hasPlaybackItem:Bool {
        get {
            return (self.playbackManager != nil)
        }
    }
    
    func startPlaybackWithUrl(_ url: URL?) {
        let source = self.playbackSourceForUrl(url)
        if let source = source {
            self.playbackManager = TWPlaybackManager(dataSource: source)
        }
    }
    
    func startPlaybackWithUrl(_ url: URL?, selectedItem: NSString?) {
        let source = self.playbackSourceForUrl(url)
        if let source = source {
            self.playbackManager?.finish()
            self.playbackManager = TWPlaybackManager(dataSource: source)
            self.selectedItem = selectedItem as? String
        }
    }
    
    func playbackSourceForUrl(_ url:URL?) -> TWPlaybackSource? {
        let fileType = TWFileTypeManager.fileType(fileUrl: url)
        let playbackSourceGeneratorFunction = self.playbackSourcesDict[fileType]
        if let playbackSourceGeneratorFunction = playbackSourceGeneratorFunction {
            return playbackSourceGeneratorFunction(self)(url)
        }
        return nil
    }
    
    func createEpubPlaybackSource(sourceUrl:URL?) -> TWPlaybackSource {
        let epubPlaybackSource = TWEpubPlaybackSource(url: sourceUrl)
        if self.selectedItem != nil {
            epubPlaybackSource.goToItemWithPath(self.selectedItem)
        }
        return epubPlaybackSource
    }
    
    func createHtmlPlaybackSource(sourceUrl:URL?) -> TWPlaybackSource {
        return TWHtmlPlaybackSource(url: sourceUrl)
    }
}
