//
//  TWTestableFileSystemManager.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWTestableFileSystemManager : TWFileSystemManager {
    
    var directoryContents: Array<String>?
    var fileContents: Data?
    var requestedDirPath: String?
    var copiedURL: URL?
    var destinationURL: URL?
    
    func contentsOfDirectoryAtPath(_ path: String!, error: NSErrorPointer) -> [AnyObject]! {
        self.requestedDirPath = path
        return self.directoryContents as [AnyObject]!
    }
    
    func contentsAtPath(_ path: String!) -> Data!
    {
        return self.fileContents
    }
    
    func copyItemAtURL(_ srcURL: URL!, toURL dstURL: URL!, error: NSErrorPointer) -> Bool {
        self.copiedURL = srcURL;
        self.destinationURL = dstURL
        return true
    }
    
    init() {
        directoryContents = nil
        fileContents = nil;
        requestedDirPath = nil
        copiedURL = nil
        destinationURL = nil
    }
}
