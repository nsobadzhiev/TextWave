//
//  TWNowPlayingManager+RemoteControl.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 2/17/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

extension TWNowPlayingManager {
    func handleRemoteControlEvent(event:UIEvent) {
        if event.type == UIEventType.RemoteControl {
            switch event.subtype {
            case .RemoteControlPlay:
                self.playbackManager?.resume()
            case .RemoteControlPause:
                self.playbackManager?.pause()
                break
            case .RemoteControlNextTrack:
                self.playbackManager?.next()
                break
            case .RemoteControlPreviousTrack:
                self.playbackManager?.previous()
                break
            case .RemoteControlTogglePlayPause:
                if self.playbackManager?.isPlaying == true {
                    self.playbackManager?.pause()
                }
                else {
                    self.playbackManager?.resume()
                }
                break
            case .RemoteControlEndSeekingBackward:
                // TODO: figure out the new position
                break;
            case .RemoteControlEndSeekingForward:
                // TODO: figure out the new position
                break;
            default:
                // do nothing
                break
            }
        }
    }
}