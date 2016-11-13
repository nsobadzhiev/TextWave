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
            let request = URLRequest(url: webPageUrl as URL, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 30.0)
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
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.responseData.append(data)
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        self.downloading = false
        self.downloadError = error as NSError?
        self.delegate?.downloadFailed(self)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        self.downloading = false
        if let savePath = self.downloadPathForWebPage() {
            let saveUrl = URL(fileURLWithPath: savePath)
            do {
                try self.responseData.write(to: saveUrl, options: NSData.WritingOptions())
            }
            catch {
                print("Unable to save html")
            }
            self.delegate?.downloadComplete(self)
        }
        else {
            self.delegate?.downloadFailed(self)
        }
    }
}
