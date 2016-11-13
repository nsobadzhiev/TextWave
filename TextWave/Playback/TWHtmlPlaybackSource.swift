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
        if let isFile = self.sourceURL?.isFileURL {
            return isFile
        }
        return false
    }
    }
    
    override init(url: URL?) {
        super.init(url: url)
        self.handleSourceUrl()
    }
    
    override var numberOfItems:Int {
        get {
            return 1
        }
    }
    
    func handleSourceUrl() {
        if self.isLocalResource {
            if let fileUrl = self.sourceURL {
                do {
                    let rawText = try NSString(contentsOf: fileUrl as URL, encoding: String.Encoding.utf8.rawValue)
                    self.currentText = self.extractText(htmlString: rawText as String)
                }
                catch {
                    print("Unable to read source from \(fileUrl.absoluteString)")
                }
            }
        }
        else {
            self.downloader = TWResourceDownloader(url: self.sourceURL, savePathURL: nil)
        }
    }
    
    func extractText(htmlString:String?) -> String {
        let textExtractor = TWTextExtractor()
        return textExtractor.extractArticle(htmlString: htmlString)
    }
    
    override func prepareResources() {
        self.downloader?.startDownloading()
    }
    
    // TWResourceDownloader
    func resourceDownloaderDidFinishDownoad(_ resourceDownloader: TWResourceDownloader) {
        self.delegate?.playbackSourceDidLoadResources(self)
    }
    
    func resourceDownloader(_ resourceDownloader: TWResourceDownloader, didFailWithError error: NSError?) {
        self.delegate?.playbackSource(self, didFailWithError: error)
    }
}
