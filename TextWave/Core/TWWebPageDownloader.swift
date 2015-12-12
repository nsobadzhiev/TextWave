//
//  TWWebPageDownloader.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 2/24/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWWebPageDownloader : TWWebPageDownloaderBase, ASIHTTPRequestDelegate {
    var webPageRequest:ASIWebPageRequest? = nil
    var webPageCache:ASIDownloadCache? = nil
    
    override var downloading:Bool {
        get {
            if self.webPageRequest?.inProgress == true {
                return true
            }
            else {
                return false
            }
        }
        set {
            
        }
    }
    
    override var downloadError:NSError? {
        get {
            return self.webPageRequest?.error
        }
        set {
            
        }
    }
    
    override func startDownload() {
        self.webPageRequest = ASIWebPageRequest(URL: self.webPageUrl)
        //self.webPageRequest?.delegate = self
        let downloadPath = self.downloadPathForWebPage()
        if downloadPath != nil && NSFileManager.defaultManager().fileExistsAtPath(downloadPath!) {
            // TODO: show error message
            //let pathUrl = NSURL(string: downloadPath!)
            do {
                try NSFileManager.defaultManager().removeItemAtPath(downloadPath!)
            }
            catch {
                print("Unable to remove exisitng file before download: \(error)")
            }
            //return
        }
        self.webPageRequest?.downloadDestinationPath = self.downloadPathForWebPage()
        self.webPageRequest?.urlReplacementMode = ASIReplaceExternalResourcesWithLocalURLs
        self.webPageRequest?.cachePolicy = ASIDoNotReadFromCacheCachePolicy
        self.webPageRequest?.didFinishSelector = Selector("requestFinished")
        self.webPageRequest?.didFailSelector = Selector("requestFailed")
        self.webPageRequest?.delegate = self
        self.webPageRequest?.cachePolicy = ASIOnlyLoadIfNotCachedCachePolicy
        let cache = ASIDownloadCache()
        cache.defaultCachePolicy = ASIOnlyLoadIfNotCachedCachePolicy
        cache.storagePath = self.downloadPathForWebPage()
        self.webPageRequest?.downloadCache = cache
        self.webPageCache = cache
        self.webPageRequest?.startAsynchronous()
    }
    
    override func stopDownload() {
        self.webPageRequest?.cancel()
    }
    
    // MARK: ASIHTTPRequestDelegate
    
    func requestFinished(request: ASIHTTPRequest!) {
        self.delegate?.downloadComplete(self)
    }
    
    func requestFailed(request: ASIHTTPRequest!) {
        self.delegate?.downloadFailed(self)
    }
}