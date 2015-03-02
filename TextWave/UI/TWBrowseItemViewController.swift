//
//  TWBrowseItemViewController.swift
//  TextWave
//
//  Created by Nikolay Markov on 11/21/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWBrowseItemViewController: UIViewController, UITextFieldDelegate, TWWebPageDownloaderDelegate {
    
    @IBOutlet var webView: UIWebView! = nil
    @IBOutlet var searchField: UITextField! = nil
    var webPageDownloader:TWWebPageDownloader? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @IBAction func didSelectDownloadButton(buttonItem: UIBarButtonItem) {
        if self.webPageDownloader?.downloading == true {
            return
        }
        if let address = self.searchField.text {
            let addressUrl = NSURL(string: address)
            if let addressUrl = addressUrl {
                self.webPageDownloader?.delegate = nil
                self.webPageDownloader = TWWebPageDownloader(url: addressUrl)
                self.webPageDownloader?.delegate = self
                self.webPageDownloader?.startDownload()
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let url = NSURL(string: textField.text)
        if let url = url {
            let request = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 30)
            self.webView.loadRequest(request)
        }
        
        return true
    }

    // MARK: - TWWebPageDownloaderDelegate
    
    func downloadFailed(downloader: TWWebPageDownloader) {
        if downloader.webPageRequest?.error == nil {
            return
        }
        let bundle:NSBundle? = nil
        let alertTitle = NSLocalizedString("Download failed", comment: "Web page download failure alert")
        let alertBody = downloader.webPageRequest?.error.localizedDescription
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        var alert = UIAlertController(title: alertTitle, message: alertBody, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func downloadComplete(downloader: TWWebPageDownloader) {
        // TODO: should probably go to sources collection view
        self.navigationController?.popViewControllerAnimated(true)
    }
}
