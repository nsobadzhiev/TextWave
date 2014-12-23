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
    func urlDownloader(downloader: UrlDownloader, didDownloadData data: NSData?)
    func urlDownloader(downloader: UrlDownloader, didFailWithError error: NSError?)
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
        let normalizedURL = self.urlPath?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let escapedUrl:String? = normalizedURL?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let theURL = NSURL(string: escapedUrl!)
        let theRequest = NSMutableURLRequest(URL: theURL!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: NSTimeInterval(k_connectionTimeout))
        theRequest.HTTPMethod = "GET"
        let connection = NSURLConnection(request: theRequest, delegate: self)
        connection?.start()
    }
    
    func downloadResource() {
        if let path = self.urlPath? {
            // creating an NSURL with a nil string throws an exception. Prevent that
            // and notify the delegate that the request failed
            self.notifyDelegateDownloadFailedWithError(nil)
            return
        }
        self.createAndStartRequest()
        self.loading = true
    }
    
    // NSURLConnection
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        responseData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        self.loading = false
        self.notifyDelegateDownloadedData(responseData)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        self.loading = false
        self.notifyDelegateDownloadFailedWithError(error)
    }
    
    // PrivateMethods
    
    func notifyDelegateDownloadedData(data: NSData?) {
        self.delegate?.urlDownloader(self, didDownloadData: data)
    }
    
    func notifyDelegateDownloadFailedWithError(error: NSError?) {
        self.delegate?.urlDownloader(self, didFailWithError: error)
    }
}
