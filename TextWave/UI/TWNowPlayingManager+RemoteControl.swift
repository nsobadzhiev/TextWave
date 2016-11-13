//
//  TWNowPlayingManager+RemoteControl.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 2/17/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

extension TWNowPlayingManager {
    func handleRemoteControlEvent(_ event:UIEvent) {
        if event.type == UIEventType.remoteControl {
            switch event.subtype {
            case .remoteControlPlay:
                self.playbackManager?.resume()
            case .remoteControlPause:
                self.playbackManager?.pause()
                break
            case .remoteControlNextTrack:
                self.playbackManager?.next()
                break
            case .remoteControlPreviousTrack:
                self.playbackManager?.previous()
                break
            case .remoteControlTogglePlayPause:
                if self.playbackManager?.isPlaying == true {
                    self.playbackManager?.pause()
                }
                else {
                    self.playbackManager?.resume()
                }
                break
            case .remoteControlEndSeekingBackward:
                // TODO: figure out the new position
                break;
            case .remoteControlEndSeekingForward:
                // TODO: figure out the new position
                break;
            default:
                // do nothing
                break
            }
        }
    }
}
