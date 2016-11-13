//
//  TWFileSystemManager.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWFileSystemManager {
    
    func contentsOfDirectoryAtPath(_ path: String) throws -> [String]
    func contentsAtPath(_ path: String) -> Data?
    func copyItemAtURL(_ srcURL: URL, toURL dstURL: URL) throws
}
