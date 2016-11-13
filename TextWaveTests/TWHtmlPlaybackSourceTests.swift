//
//  TWHtmlPlaybackSourceTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

class TWHtmlPlaybackSourceTests: XCTestCase, TWPlaybackSourceDelegate {
    
    let playbackSource = TWHtmlPlaybackSource(url: URL(string: "http://testPage.com"))
    var wasNotifiedResourcesLoaded = false
    var wasNotifiedResourcesLoadFailed = false
    var resourceLoadError: NSError? = nil

    override func setUp() {
        super.setUp()
        playbackSource.delegate = self;
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func playbackSourceDidLoadResources(_ playbackSource: TWPlaybackSource) {
        wasNotifiedResourcesLoaded = true
    }
    
    func playbackSource(_ playbackSource: TWPlaybackSource, didFailWithError error: NSError?) {
        wasNotifiedResourcesLoadFailed = true
        resourceLoadError = error
    }

    func testInitializingWithLocalResource() {
        let htmlSource = TWHtmlPlaybackSource(url: URL(string: "file://path/to/file.html"))
        XCTAssertTrue(htmlSource.isLocalResource, "TWHtmlPlaybackSource should be able to distinguish between local and remote URLs")
    }

    func testInitializingWithRemoteResource() {
        XCTAssertFalse(playbackSource.isLocalResource, "TWHtmlPlaybackSource should be able to distinguish between local and remote URLs")
    }
    
//    func testStartingDownloadRemoteResource() {
//        playbackSource.prepareResources()
//        XCTAssertTrue(playbackSource.downloader?.loading == true, "Should start downloading the remote file")
//    }

    func testHandlingDownloadingDone() {
        playbackSource.resourceDownloaderDidFinishDownoad(playbackSource.downloader!)
        XCTAssertTrue(self.wasNotifiedResourcesLoaded, "The playback source should notify it's delegate as soon as all resources have been downloaded")
    }
    
    func testHandlingDownloadFailed() {
        playbackSource.resourceDownloader(playbackSource.downloader!, didFailWithError: nil)
        XCTAssertTrue(self.wasNotifiedResourcesLoadFailed, "Should notify the delegate that resource loading has failed")
    }
    
    func testHandlingDownloadFailedErrorObject() {
        var downloaderError = NSError(domain: "test domain", code: 0, userInfo: nil)
        playbackSource.resourceDownloader(playbackSource.downloader!, didFailWithError: downloaderError)
        XCTAssertTrue(downloaderError === self.resourceLoadError, "Should pass the error object received from thr resource downloader")
    }
}
