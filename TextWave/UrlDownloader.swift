//
//  UrlDownloader.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

/*
* The UrlDownloaderDelegate is a protocol describing all delegate methods
* that UrlDownloader invokes
**/

protocol UrlDownloaderDelegate {
    func urlDownloader(_ downloader: UrlDownloader, didDownloadData data: Data?)
    func urlDownloader(_ downloader: UrlDownloader, didFailWithError error: NSError?)
}

/*
* UrlDownloader is a class implementing functionality for downloading
* the contents of a URL asynchroniously.
**/

class UrlDownloader : NSObject, NSURLConnectionDataDelegate {
    
    var responseData: NSMutableData? = nil
    var urlPath: String? = nil
    var loading: Bool = false
    var delegate: UrlDownloaderDelegate? = nil
    let k_connectionTimeout = 120
    
    init(path: String?) {
        self.urlPath = path
    }
    
    // can be overriden in subclasses to alter the request
    // should not be called from external classes
    func createAndStartRequest() {
        let normalizedURL = self.urlPath?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString?
        let escapedUrl:String? = normalizedURL?.removingPercentEncoding
        let theURL = URL(string: escapedUrl!)
        let theRequest = NSMutableURLRequest(url: theURL!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: TimeInterval(k_connectionTimeout))
        theRequest.httpMethod = "GET"
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self)
        connection?.start()
    }
    
    func downloadResource() {
        if self.urlPath != nil {
            // creating an NSURL with a nil string throws an exception. Prevent that
            // and notify the delegate that the request failed
            self.notifyDelegateDownloadFailedWithError(nil)
            return
        }
        self.createAndStartRequest()
        self.loading = true
    }
    
    // NSURLConnection
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        responseData?.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        self.loading = false
        self.notifyDelegateDownloadedData(responseData as Data?)
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        self.loading = false
        self.notifyDelegateDownloadFailedWithError(error as NSError?)
    }
    
    // PrivateMethods
    
    func notifyDelegateDownloadedData(_ data: Data?) {
        self.delegate?.urlDownloader(self, didDownloadData: data)
    }
    
    func notifyDelegateDownloadFailedWithError(_ error: NSError?) {
        self.delegate?.urlDownloader(self, didFailWithError: error)
    }
}
