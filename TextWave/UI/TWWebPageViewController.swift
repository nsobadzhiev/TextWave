//
//  TWWebPageViewController.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 10/29/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWWebPageViewController: TWPublicationPreviewViewControllerProtocol, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView! = nil
    
    var pageUrl: NSURL? = nil {
        didSet {
            self.loadRequest(self.pageUrl)
        }
    }
    
    override func viewDidLoad() {
        self.loadRequest(self.pageUrl)
        self.webView.delegate = self
    }
    
    func loadRequest(requestUrl:NSURL?) {
        if let requestUrl = requestUrl {
            if let webContainer = self.webView {
                let request = NSURLRequest(URL: requestUrl, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30)
                self.webView.loadRequest(request)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ListenWebPageSegue" {
            TWNowPlayingManager.instance.startPlaybackWithUrl(self.pageUrl)
            let nowPlayingController = segue.destinationViewController as TWNowPlayingViewController
            nowPlayingController.nowPlayingManager = TWNowPlayingManager.instance
        }
    }
    
    // MARK: UIWebViewDelegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
}