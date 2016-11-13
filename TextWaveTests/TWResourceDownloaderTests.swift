//
//  TWResourceDownloaderTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import XCTest

class TWResourceDownloaderTests: XCTestCase, TWResourceDownloaderDelegate {
    
    let resourceURL = URL.URLWithString("http://path/to/file")
    var resourceDownloader: TWMockResourceDownloader! = nil
    var hasNotifiedRequestComplete = false
    var hasNotifiedRequestFailed = false

    override func setUp() {
        super.setUp()
        resourceDownloader = TWMockResourceDownloader(url: resourceURL)
    }
    
    override func tearDown() {
        resourceDownloader = nil
        super.tearDown()
    }
    
    func resourceDownloaderDidFinishDownoad(_ resourceDownloader: TWResourceDownloader) {
        hasNotifiedRequestComplete = true
    }
    
    func resourceDownloader(_ resourceDownloader: TWResourceDownloader, didFailWithError error: NSError?) {
        hasNotifiedRequestFailed = true
    }

    func testInitializingUrlDownloaderWithUrl() {
        if let urlPath = resourceDownloader.urlDownloader?.urlPath {
            NSLog(urlPath)
            NSLog(resourceURL.absoluteString)
            XCTAssertTrue(urlPath == resourceURL.absoluteString, "Should initialize the url downloader with the URL provided in the constructor")
        }
    }

    func testInitializingWithSavePath() {
        let saveUrl = URL(string: "file://path/to/save/file/at")
        resourceDownloader = TWMockResourceDownloader(url: resourceURL, savePathURL: saveUrl)
        XCTAssertTrue(resourceDownloader.saveUrl === saveUrl, "Should be able to set the path to save the resource at")
    }
    
    func testInitializingWithLocalUrl() {
        resourceDownloader = TWMockResourceDownloader(url: URL(string: "file://path/to/file"))
        XCTAssertNil(resourceDownloader.urlDownloader, "Should return nil if the provided url is from a file url")
    }
    
    func testInitializingWithRemoteSaveUrl() {
        resourceDownloader = TWMockResourceDownloader(url: resourceURL, savePathURL: URL(string: "http://remote/path"))
        XCTAssertNil(resourceDownloader.urlDownloader, "Should return nil if the provided save url is remote")
    }
    
    func testInitializingWithNilSaveUrl() {
        resourceDownloader = TWMockResourceDownloader(url: resourceURL, savePathURL: nil)
        XCTAssertNotNil(resourceDownloader.urlDownloader, "Should allow TWResourceDownloader instances with nil saveUrl properties")
    }
//    
//    func testStartingDownload() {
//        resourceDownloader.setDownloader(UrlDownloader(path: resourceURL.absoluteString))
//        resourceDownloader.startDownloading()
//        XCTAssertTrue(resourceDownloader.urlDownloader?.loading == true, "Calling the startDownloading method should result in initiating the request")
//    }
    
    func testCompletingDownload() {
        resourceDownloader.delegate = self
        let mockDownloader = MockUrlDownloader(path: resourceURL.absoluteString)
        mockDownloader.shouldSimulateCompletion = true
        mockDownloader.delegate = resourceDownloader
        resourceDownloader.urlDownloader = mockDownloader
        resourceDownloader.startDownloading()
        XCTAssertTrue(hasNotifiedRequestComplete, "Should call a delegate method informing completion")
    }
    
    func testRequestFailure() {
        resourceDownloader.delegate = self
        let mockDownloader = MockUrlDownloader(path: resourceURL.absoluteString)
        mockDownloader.shouldSimulateFailure = true
        mockDownloader.delegate = resourceDownloader
        resourceDownloader.urlDownloader = mockDownloader
        resourceDownloader.startDownloading()
        XCTAssertTrue(hasNotifiedRequestFailed, "Should call a delegate method informing failure")
    }
    
    func testSavingDownloadedFile() {
        resourceDownloader.delegate = self
        let mockDownloader = MockUrlDownloader(path: resourceURL.absoluteString)
        mockDownloader.shouldSimulateCompletion = true
        mockDownloader.delegate = resourceDownloader
        resourceDownloader.urlDownloader = mockDownloader
        resourceDownloader.startDownloading()
        XCTAssertTrue(resourceDownloader.hasSavedFile, "Should call the saveData method in order to save the data into a file")
    }
}
