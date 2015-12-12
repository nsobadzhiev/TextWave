//
//  TWLockScreenNowPlayingInfo.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 2/13/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import MediaPlayer

class TWLockScreenNowPlayingInfo {
    var playbackManager: TWPlaybackManager? = nil
    
    init () {
        self.setupNotifications()
    }
    
    func setupNowPlayingInfo() {
        var nowPlayingInfo = Dictionary<String, AnyObject>()
        let fileMetadata = TWFileMetadataFactory.metadataForFile(self.playbackManager?.playbackSource?.sourceURL)
        let itemName = fileMetadata?.titleForFile()
        let itemArtwork = fileMetadata?.thumbnailForFile()
        let artist = self.playbackManager?.playbackSource?.subtitle
        let numberOfItems = self.playbackManager?.playbackSource?.numberOfItems
        let itemNumber = self.playbackManager?.playbackSource?.currentItemIndex
        if let itemName = itemName {
            nowPlayingInfo[MPMediaItemPropertyTitle] = itemName
        }
        if let artist = artist {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        }
        if let itemArtwork = itemArtwork {
            let artworkMediaItem = MPMediaItemArtwork(image: itemArtwork)
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artworkMediaItem
        }
        nowPlayingInfo[MPMediaItemPropertyAlbumTrackCount] = numberOfItems
        nowPlayingInfo[MPMediaItemPropertyAlbumTrackNumber] = itemNumber
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingInfo
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    func removeNowPlayingInfo() {
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nil
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
    }
    
    func setupNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        notificationCenter.addObserverForName(UIApplicationWillResignActiveNotification, object: nil, queue: mainQueue) { _ in
            if self.playbackManager != nil && self.playbackManager?.isPlaying == true {
                self.setupNowPlayingInfo()
            }
        }
    }
}