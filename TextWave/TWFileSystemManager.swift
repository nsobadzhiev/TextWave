//
//  TWFileSystemManager.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWFileSystemManager {
    
    func contentsOfDirectoryAtPath(path: String, error: NSErrorPointer) -> [AnyObject]?
    func contentsAtPath(path: String) -> NSData?
    func copyItemAtURL(srcURL: NSURL, toURL dstURL: NSURL, error: NSErrorPointer) -> Bool
}