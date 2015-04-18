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
            webView.scalesPageToFit = true
            let thumbnailRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30)
            webView.delegate = self
            webView.loadRequest(thumbnailRequest)
            self.webViews.append(webView)
            let thumbnail = self.screenshotOfView(webView)
            //self.thumbnailsFileManager.saveThumbnail(thumbnail, forUrl: url)
            self.successBlock(thumbnailView: webView)
        }
    }
    
    func screenshotOfView(view:UIView?) -> UIImage? {
        if let view = view {
            let imageSize = self.thumbnailSize
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            let context = UIGraphicsGetCurrentContext()
            CGContextSaveGState(context)
            CGContextTranslateCTM(context, view.frame.size.width, view.frame.size.height)
            CGContextConcatCTM(context, view.transform)
            CGContextTranslateCTM(context, -view.frame.size.width * view.layer.anchorPoint.x, -view.frame.size.height * view.layer.anchorPoint.y)
            view.layer.renderInContext(context)
            CGContextRestoreGState(context)
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
        let thumbnail = self.screenshotOfView(webView)
        self.thumbnailsFileManager.saveThumbnail(thumbnail, forUrl: webView.request?.URL)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.failureBlock(error: error)
    }
}