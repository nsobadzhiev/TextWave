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
            nowPlayingInfo[MPMediaItemPropertyTitle] = itemName as AnyObject?
        }
        if let artist = artist {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist as AnyObject?
        }
        if let itemArtwork = itemArtwork {
            let artworkMediaItem = MPMediaItemArtwork(image: itemArtwork)
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artworkMediaItem
        }
        nowPlayingInfo[MPMediaItemPropertyAlbumTrackCount] = numberOfItems as AnyObject?
        nowPlayingInfo[MPMediaItemPropertyAlbumTrackNumber] = itemNumber as AnyObject?
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    func removeNowPlayingInfo() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        notificationCenter.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: nil, queue: mainQueue) { _ in
            if self.playbackManager != nil && self.playbackManager?.isPlaying == true {
                self.setupNowPlayingInfo()
            }
        }
    }
}
