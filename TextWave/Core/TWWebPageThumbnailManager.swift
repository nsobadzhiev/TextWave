//
//  TWWebPageThumbnailManager.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/28/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWWebPageThumbnailManager : NSObject, UIWebViewDelegate {
    
    var thumbnailSize:CGSize = CGSizeMake(140.0, 160.0)
    let thumbnailsFileManager = TWThumbnailFileManager()
    var successBlock: ((thumbnailView:UIView) -> Void)! = nil
    var failureBlock: ((error:NSError) -> Void)! = nil
    var webViews:Array<UIWebView> = []
    var urls:Array<NSURL> = []
    
    deinit {
        for webView in self.webViews {
            webView.delegate = nil
        }
    }
    
    func thumbnailForWebPage(pageUrl: NSURL?, successBlock:(thumbnailView:UIView) -> Void, failBlock:(error:NSError) -> Void) {
        let cachedThumbnail = self.thumbnailsFileManager.cachedThumbnailForUrl(pageUrl)
        if let cachedThumbnail = cachedThumbnail {
            successBlock(thumbnailView: cachedThumbnail)
        }
        else {
            self.successBlock = successBlock
            self.failureBlock = failBlock
            self.fetchThumbnail(pageUrl)
        }
    }
    
    func fetchThumbnail(url:NSURL?) {
        if let url = url {
            let webView = UIWebView(frame: CGRectMake(0, 0, self.thumbnailSize.width, self.thumbnailSize.height))
            self.successBlock(thumbnailView: webView)
            webView.scalesPageToFit = true
            webView.delegate = self
            if url.fileURL == true {
                let htmlString = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)
                let baseUrl = TWWebPageDownloadManager.defaultDownloadManager.baseUrlForWebPage(url.lastPathComponent)
                webView.loadHTMLString(htmlString as? String, baseURL: baseUrl)
            }
            else {
                let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30)
                webView.loadRequest(request)
            }
            self.webViews.append(webView)
            self.urls.append(url)
        }
    }
    
    func screenshotOfView(view:UIView?) -> UIImage? {
        if let view = view {
            let imageSize = self.thumbnailSize
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
            let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return thumbnail
        }
        else {
            return nil
        }
    }
    
    // MARK: WebView delegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let scrollView = webView.scrollView
        let zoom = webView.bounds.size.width/scrollView.contentSize.width
        scrollView.setZoomScale(zoom, animated: false)
        
        let thumbnail = self.screenshotOfView(webView)
        let webViewIndex = find(self.webViews, webView)
        let url = self.urls[webViewIndex!]
        self.thumbnailsFileManager.saveThumbnail(thumbnail, forUrl: url)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.failureBlock(error: error)
    }
}