//
//  TWWebPageDownloader.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 2/24/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWWebPageDownloaderDelegate {
    func downloadComplete(downloader:TWWebPageDownloader)
    func downloadFailed(downloader:TWWebPageDownloader)
}

class TWWebPageDownloader : NSObject, ASIHTTPRequestDelegate {
    var webPageUrl:NSURL? = nil
    var webPageRequest:ASIWebPageRequest? = nil
    var delegate:TWWebPageDownloaderDelegate? = nil
    
    var downloading:Bool {
        get {
            if self.webPageRequest?.inProgress == true {
                return true
            }
            else {
                return false
            }
        }
    }
    
    init(url:NSURL?) {
        self.webPageUrl = url
    }
    
    func startDownload() {
        self.webPageRequest = ASIWebPageRequest(URL: self.webPageUrl)
        //self.webPageRequest?.delegate = self
        let downloadPath = self.downloadPathForWebPage()
        if downloadPath != nil && NSFileManager.defaultManager().fileExistsAtPath(downloadPath!) {
            // TODO: show error message
            return
        }
        self.webPageRequest?.downloadDestinationPath = self.downloadPathForWebPage()
        self.webPageRequest?.urlReplacementMode = ASIReplaceExternalResourcesWithLocalURLs
        self.webPageRequest?.cachePolicy = ASIDoNotReadFromCacheCachePolicy
        self.webPageRequest?.didFinishSelector = Selector("requestFinished")
        self.webPageRequest?.didFailSelector = Selector("requestFailed")
        var cache = ASIDownloadCache()
        cache.defaultCachePolicy = ASIOnlyLoadIfNotCachedCachePolicy
        cache.storagePath = self.downloadPathForWebPage()
        self.webPageRequest?.downloadCache = cache
        self.webPageRequest?.startAsynchronous()
    }
    
    func stopDownload() {
        self.webPageRequest?.cancel()
    }
    
    func downloadPathForWebPage() -> String? {
        // form the directory name by concatenating host name and directory path
        let urlHost = self.webPageUrl?.host
        let urlDirPath = self.webPageUrl?.lastPathComponent
        let docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        var fullPath = urlHost
        if var fullPath = fullPath {
            if let urlDirPath = urlDirPath {
                fullPath = fullPath + "-" + urlDirPath
                fullPath = docsDir.stringByAppendingPathComponent(fullPath)
                return fullPath
            }
        }
        return nil
    }
    
    // MARK: ASIHTTPRequestDelegate
    
    func requestFinished(request: ASIHTTPRequest!) {
        self.delegate?.downloadComplete(self)
    }
    
    func requestFailed(request: ASIHTTPRequest!) {
        self.delegate?.downloadFailed(self)
    }
}