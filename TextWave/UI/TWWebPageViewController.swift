//
//  TWWebPageViewController.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 10/29/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import UIKit

class TWWebPageViewController: TWPublicationPreviewViewControllerProtocol, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView! = nil
    
    var pageUrl: URL? = nil {
        didSet {
            if (self.webView != nil) {
                self.loadRequest(self.pageUrl)
            }
        }
    }
    
    override func viewDidLoad() {
        self.loadRequest(self.pageUrl)
        self.webView.delegate = self
    }
    
    func loadRequest(_ requestUrl:URL?) {
        if let requestUrl = requestUrl {
            if requestUrl.isFileURL == true {
                do {
                    let htmlString = try NSString(contentsOf: pageUrl!, encoding: String.Encoding.utf8.rawValue)
                    let baseUrl = TWWebPageDownloadManager.defaultDownloadManager.baseUrlForWebPage(pageUrl?.lastPathComponent)
                    self.webView.loadHTMLString(htmlString as String, baseURL: baseUrl)
                }
                catch {
                    print("Unable to load html from \(pageUrl?.absoluteString)")
                }
                
            }
            else {
                let request = URLRequest(url: requestUrl, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
                self.webView.loadRequest(request)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListenWebPageSegue" {
            TWNowPlayingManager.instance.startPlaybackWithUrl(self.pageUrl)
            let nowPlayingController = segue.destination as? TWNowPlayingViewController
            nowPlayingController?.nowPlayingManager = TWNowPlayingManager.instance
        }
    }
    
    // MARK: UIWebViewDelegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
}
