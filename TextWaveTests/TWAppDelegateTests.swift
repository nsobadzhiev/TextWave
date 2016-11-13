//
//  TWAppDelegateTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWAppDelegateTests: XCTestCase {
    
    var appDelegate: AppDelegate = AppDelegate();

    override func setUp() {
        super.setUp()
        appDelegate.application(UIApplication.sharedApplication(), didFinishLaunchingWithOptions: nil)
    }
    
    override func tearDown() {
        //self.appDelegate = nil;
        super.tearDown()
    }
    
    func testAbilityToCopyOpenedFilesInTheSandbox() {
        var fileSystemManager = TWTestableFileSystemManager()
        appDelegate.fileManager = fileSystemManager as TWFileSystemManager;
        let openedURL = URL(string: "file://path/to/resource");
        appDelegate.application(UIApplication.sharedApplication(), openURL: openedURL, sourceApplication: "test.app", annotation: nil)
        XCTAssertEqual(fileSystemManager.copiedURL!, openedURL, "The app delegate should ask the file manager to copy the file in the documents dir");
    }
    
    func testAbilityToCopyOpenedFilesInTheRightDestination() {
        var fileSystemManager = TWTestableFileSystemManager()
        appDelegate.fileManager = fileSystemManager as TWFileSystemManager;
        let openedURL = URL(string: "file://path/to/resource.epub");
        appDelegate.application(UIApplication.sharedApplication(), openURL: openedURL, sourceApplication: "test.app", annotation: nil)
        let documentsDirectoryRaw = NSHomeDirectory() + "Documents";
        let documentsDirectory = documentsDirectoryRaw.addingPercentEscapes(using: String.Encoding.utf8)
        let destinationPath = documentsDirectory.stringByAppendingPathComponent("resource.epub")
        XCTAssertEqual(fileSystemManager.destinationURL!.absoluteString, destinationPath, "The app delegate should ask the file manager to copy the file in the documents dir");
    }

}
