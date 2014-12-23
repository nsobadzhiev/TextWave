//
//  TWMockResourceDownloader.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/18/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWMockResourceDownloader : TWResourceDownloader {
    var hasSavedFile: Bool = false
    
    func setDownloader(downloader: UrlDownloader?) {
        urlDownloader = downloader
        urlDownloader!.delegate = self
    }
    
    override func saveData(data: NSData?) {
        self.hasSavedFile = true
    }
}
