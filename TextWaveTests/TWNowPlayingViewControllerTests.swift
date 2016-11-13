//
//  TWNowPlayingViewControllerTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/5/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWNowPlayingViewControllerTests: XCTestCase {
    
    let nowPlayingManager = TWNowPlayingManager.instance
    var nowPlayingController: TWNowPlayingViewController! = nil

    override func setUp() {
        super.setUp()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.nowPlayingController = mainStoryboard.instantiateViewController(withIdentifier: "TWNowPlayingViewController") as! TWNowPlayingViewController
        let newSource = TWPlaybackSource(url: nil)
        let newPlayback = TWMockPlaybackManager(dataSource: newSource)
        nowPlayingManager.playbackManager = newPlayback
        self.nowPlayingController.nowPlayingManager = nowPlayingManager; // set it again in order to have
        // the changes in playbackManager take effect
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInstantiatingTheControllerFromStoryboard() {
        XCTAssertNotNil(self.nowPlayingController, "Should be able to create the controller from the main storyboard")
    }

    func testRetrievingThePlaybackManager() {
        let view = self.nowPlayingController!.view
        let playbackFromController = self.nowPlayingController!.playbackManager
        let playbackFromManager = nowPlayingManager.playbackManager
        XCTAssertTrue(playbackFromController === playbackFromManager, "TWNowPlayingViewController should get the current playback manager from the TWNowPlayingManager instance")
    }
    
    func testStartingPlayback() {
        nowPlayingController.onPlayTap(self)
        let playbackManager = nowPlayingController.playbackManager? as! TWMockPlaybackManager
        XCTAssertTrue(playbackManager.wasAskedToPlay, "Tapping on the play button should result in starting playback")
    }
    
    func testGoingToNextItem() {
        nowPlayingController.onNextTap(self)
        let playbackManager = nowPlayingController.playbackManager? as! TWMockPlaybackManager
        XCTAssertTrue(playbackManager.wasAskedToPlayNext, "Tapping on the play button should result in starting playback for the next item")
    }

    func testGoingToPreviousItem() {
        nowPlayingController.onPreviousTap(self)
        let playbackManager = nowPlayingController.playbackManager? as! TWMockPlaybackManager
        XCTAssertTrue(playbackManager.wasAskedToPlayPrevious, "Tapping on the play button should result in starting playback for the previous item")
    }
    
    func testSkippingForward() {
        nowPlayingController.onSkipForwardTap(self)
        let playbackManager = nowPlayingController.playbackManager? as! TWMockPlaybackManager
        XCTAssertTrue(playbackManager.wasAskedToSkipForward, "Tapping on the play button should result in skipping forward")
    }
    
    func testSkippingBackwards() {
        nowPlayingController.onSkipBackwardsTap(self)
        let playbackManager = nowPlayingController.playbackManager? as! TWMockPlaybackManager
        XCTAssertTrue(playbackManager.wasAskedToSkipBackwards, "Tapping on the play button should result in skipping backwards")
    }
    
    func testSettingNewSliderValue() {
        let mockSlider = UISlider()
        mockSlider.value = 0.3
        nowPlayingController.onProgressSliderChangedValue(mockSlider)
        let playbackManager = nowPlayingController.playbackManager? as! TWMockPlaybackManager
        XCTAssertEqual(playbackManager.setPlaybackProgress, mockSlider.value, "Should set the progress position based on the value of the preogress slider")
    }
}
