//
//  TWNowPlayingManagerTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/5/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

class TWNowPlayingManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAbilityToGetNowPlayingManagerInstance() {
        XCTAssertNotNil(TWNowPlayingManager.instance, "Should be able to get a reference to the Now playing manager")
    }

    func testInstanceIsAlwaysTheSame() {
        let firstInstance = TWNowPlayingManager.instance
        let secondInstance = TWNowPlayingManager.instance
        XCTAssertTrue(firstInstance === secondInstance, "There should be only one instance of TWNowPlayingManager")
    }
    
    func testAbilityToSetPlaybackManager() {
        let source = TWPlaybackSource(url: nil)
        let playback = TWPlaybackManager(dataSource: source)
        TWNowPlayingManager.instance.playbackManager = playback
        let setPlayback = TWNowPlayingManager.instance.playbackManager
        XCTAssertTrue(playback === setPlayback, "Should be able to store a playback instance as the current one")
    }
}
