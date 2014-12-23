//
//  TWHtmlPlaybackSource.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/20/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWHtmlPlaybackSource: TWTextPlaybackSource, TWResourceDownloaderDelegate {
    
    var downloader: TWResourceDownloader? = nil
    var isLocalResource: Bool {
    get {
        if let isFile = self.sourceURL?.fileURL {
            return isFile
        }
        return false
    }
    }
    
    override init(url: NSURL?) {
        super.init(url: url)
        self.handleSourceUrl()
    }
    
    func handleSourceUrl() {
        if self.isLocalResource {
            if let fileUrl = self.sourceURL {
                let rawText = NSString(contentsOfURL: fileUrl, encoding: NSUTF8StringEncoding, error: nil)
                self.currentText = self.extractText(htmlString: self.currentText)
            }
        }
        else {
            self.downloader = TWResourceDownloader(url: self.sourceURL, savePathURL: nil)
        }
    }
    
    func extractText(#htmlString:String?) -> String {
        return TTRArticleExtractor.articleText(htmlString)
    }
    
    override func prepareResources() {
        self.downloader?.startDownloading()
    }
    
    // TWResourceDownloader
    func resourceDownloaderDidFinishDownoad(resourceDownloader: TWResourceDownloader) {
        self.delegate?.playbackSourceDidLoadResources(self)
    }
    
    func resourceDownloader(resourceDownloader: TWResourceDownloader, didFailWithError error: NSError?) {
        self.delegate?.playbackSource(self, didFailWithError: error)
    }
}