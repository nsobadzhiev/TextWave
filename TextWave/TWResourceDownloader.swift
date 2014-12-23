//
//  TWResourceDownloader.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/18/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWResourceDownloaderDelegate {
    func resourceDownloaderDidFinishDownoad(resourceDownloader: TWResourceDownloader)
    func resourceDownloader(resourceDownloader: TWResourceDownloader, didFailWithError error: NSError?)
}

class TWResourceDownloader: UrlDownloaderDelegate {
    var urlDownloader: UrlDownloader? = nil
    var saveUrl: NSURL? = nil
    var loading: Bool {
    get {
        if let isLoading = urlDownloader?.loading {
            return isLoading
        }
        return false
    }
    }
    var delegate: TWResourceDownloaderDelegate? = nil
    
    init(url: NSURL?) {
        if url != nil && url?.fileURL == false {
            urlDownloader = UrlDownloader(path: url?.absoluteString)
            self.urlDownloader!.delegate = self
        }
    }
    
    convenience init(url: NSURL?, savePathURL: NSURL?) {
        var initUrl:NSURL? = nil
        if savePathURL == nil || savePathURL?.fileURL == true {
            // only fully initialize the object if the save URL is a file URL
            initUrl = url
        }
        self.init(url: initUrl)
        self.saveUrl = savePathURL
    }
    
    func startDownloading() {
        urlDownloader?.downloadResource()
    }
    
    func saveData(data: NSData?) {
        data?.writeToURL(self.saveUrl!, atomically:false)
    }
    
    // UrlDownloaderDelegate
    
    func urlDownloader(downloader: UrlDownloader, didDownloadData data: NSData?) {
        self.saveData(data)
        self.delegate?.resourceDownloaderDidFinishDownoad(self)
    }
    
    func urlDownloader(downloader: UrlDownloader, didFailWithError error: NSError?) {
        self.delegate?.resourceDownloader(self, didFailWithError: error)
    }
}
