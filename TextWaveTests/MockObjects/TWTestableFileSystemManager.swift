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
    var fileContents: NSData?
    var requestedDirPath: String?
    var copiedURL: NSURL?
    var destinationURL: NSURL?
    
    func contentsOfDirectoryAtPath(path: String!, error: NSErrorPointer) -> [AnyObject]! {
        self.requestedDirPath = path
        return self.directoryContents
    }
    
    func contentsAtPath(path: String!) -> NSData!
    {
        return self.fileContents
    }
    
    func copyItemAtURL(srcURL: NSURL!, toURL dstURL: NSURL!, error: NSErrorPointer) -> Bool {
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