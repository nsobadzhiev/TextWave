//
//  TWWebPageThumbnailManager.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/28/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWWebPageThumbnailManager : NSObject, UIWebViewDelegate {
    
    var thumbnailSize:CGSize = CGSize(width: 140.0, height: 160.0)
    let thumbnailsFileManager = TWThumbnailFileManager()
    var successBlock: ((_ thumbnailView:UIView) -> Void)! = nil
    var failureBlock: ((_ error:Error) -> Void)! = nil
    var webViews:Array<UIWebView> = []
    var urls:Array<URL> = []
    
    deinit {
        for webView in self.webViews {
            webView.delegate = nil
        }
    }
    
    func thumbnailForWebPage(_ pageUrl: URL?, successBlock:@escaping (_ thumbnailView:UIView) -> Void, failBlock:@escaping (_ error:Error) -> Void) {
        let cachedThumbnail = self.thumbnailsFileManager.cachedThumbnailForUrl(pageUrl)
        if let cachedThumbnail = cachedThumbnail {
            successBlock(cachedThumbnail)
        }
        else {
            self.successBlock = successBlock
            self.failureBlock = failBlock
            self.fetchThumbnail(pageUrl)
        }
    }
    
    func fetchThumbnail(_ url:URL?) {
        if let url = url {
            let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.thumbnailSize.width, height: self.thumbnailSize.height))
            self.successBlock(webView)
            webView.scalesPageToFit = true
            webView.delegate = self
            if url.isFileURL == true {
                do {
                    let htmlString = try NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
                    let baseUrl = TWWebPageDownloadManager.defaultDownloadManager.baseUrlForWebPage(url.lastPathComponent)
                    webView.loadHTMLString(htmlString as String, baseURL: baseUrl)
                }
                catch {
                    // TODO
                }
            }
            else {
                let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
                webView.loadRequest(request)
            }
            self.webViews.append(webView)
            self.urls.append(url)
        }
    }
    
    func screenshotOfView(_ view:UIView?) -> UIImage? {
        if let view = view {
            let imageSize = view.bounds.size
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return thumbnail
        }
        else {
            return nil
        }
    }
    
    // MARK: WebView delegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let scrollView = webView.scrollView
        let zoom = webView.bounds.size.width/scrollView.contentSize.width
        scrollView.setZoomScale(zoom, animated: false)
        
        let thumbnail = self.screenshotOfView(webView)
        let webViewIndex = self.webViews.index(of: webView)
        let url = self.urls[webViewIndex!]
        _ = self.thumbnailsFileManager.saveThumbnail(thumbnail, forUrl: url)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.failureBlock(error)
    }
}
