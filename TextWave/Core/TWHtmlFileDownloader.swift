//
//  TWFileDownloader.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 3/21/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWHtmlFileDownloader : TWWebPageDownloaderBase, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    var urlConnection:NSURLConnection? = nil
    var responseData:NSMutableData = NSMutableData()
    
    override func startDownload() {
        if let webPageUrl = self.webPageUrl {
            self.urlConnection?.cancel()
            let request = NSURLRequest(URL: webPageUrl, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 30.0)
            self.urlConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)
            self.downloading = true
        }
    }
    
    override func stopDownload() {
        self.urlConnection?.cancel()
        self.downloading = false
        self.responseData = NSMutableData()
    }
    
    // MARK: Connection delegate methods
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.responseData.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.downloading = false
        self.downloadError = error
        self.delegate?.downloadFailed(self)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        self.downloading = false
        if let savePath = self.downloadPathForWebPage() {
            let saveUrl = NSURL(fileURLWithPath: savePath)
            var writeError:NSError? = nil
            self.responseData.writeToURL(saveUrl!, options: NSDataWritingOptions.allZeros, error: &writeError)
            self.delegate?.downloadComplete(self)
        }
        else {
            self.delegate?.downloadFailed(self)
        }
    }
}