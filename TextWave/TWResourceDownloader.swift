//
//  TWResourceDownloader.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/18/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWResourceDownloaderDelegate {
    func resourceDownloaderDidFinishDownoad(_ resourceDownloader: TWResourceDownloader)
    func resourceDownloader(_ resourceDownloader: TWResourceDownloader, didFailWithError error: NSError?)
}

class TWResourceDownloader: UrlDownloaderDelegate {
    var urlDownloader: UrlDownloader? = nil
    var saveUrl: URL? = nil
    var loading: Bool {
    get {
        if let isLoading = urlDownloader?.loading {
            return isLoading
        }
        return false
    }
    }
    var delegate: TWResourceDownloaderDelegate? = nil
    
    init(url: URL?) {
        if url != nil && url?.isFileURL == false {
            urlDownloader = UrlDownloader(path: url?.absoluteString)
            self.urlDownloader!.delegate = self
        }
    }
    
    convenience init(url: URL?, savePathURL: URL?) {
        var initUrl:URL? = nil
        if savePathURL == nil || savePathURL?.isFileURL == true {
            // only fully initialize the object if the save URL is a file URL
            initUrl = url
        }
        self.init(url: initUrl)
        self.saveUrl = savePathURL
    }
    
    func startDownloading() {
        urlDownloader?.downloadResource()
    }
    
    func saveData(_ data: Data?) {
        try? data?.write(to: self.saveUrl!, options: [])
    }
    
    // UrlDownloaderDelegate
    
    func urlDownloader(_ downloader: UrlDownloader, didDownloadData data: Data?) {
        self.saveData(data)
        self.delegate?.resourceDownloaderDidFinishDownoad(self)
    }
    
    func urlDownloader(_ downloader: UrlDownloader, didFailWithError error: NSError?) {
        self.delegate?.resourceDownloader(self, didFailWithError: error)
    }
}
