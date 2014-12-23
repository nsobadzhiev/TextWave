//
//  TWPlaybackSourceTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/22/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import XCTest

class TWPlaybackSourceTests: XCTestCase {
    
    var playbackURL: NSURL? = NSURL(string: "file://path/to/file")
    var playbackSource: TWPlaybackSource! = nil

    override func setUp() {
        super.setUp()
        playbackSource = TWPlaybackSource(url: playbackURL)
    }
    
    override func tearDown() {
        playbackSource = nil
        super.tearDown()
    }

    func testSettingSourceURL() {
        let areEqual = playbackSource.sourceURL == playbackURL
        XCTAssertTrue(areEqual, "Should save the URL provided in the initializer")
    }

    func testIncrementsCurrentIndex() {
        playbackSource.goToNextItem()
        XCTAssertEqual(playbackSource.currentItemIndex, 0, "Should have incremented the index with 0 after a call to goToNextItem");
    }
    
    func testDecrementCurrentIndex() {
        playbackSource.goToNextItem()
        playbackSource.goToNextItem()
        playbackSource.goToNextItem()
        playbackSource.goToPreviousItem()
        XCTAssertEqual(playbackSource.currentItemIndex, 1, "Should have the index of 1 after a call to goToPreviousItem");
    }
}
