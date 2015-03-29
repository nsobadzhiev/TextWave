//
//  TWBrowseItemViewController.swift
//  TextWave
//
//  Created by Nikolay Markov on 11/21/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWBrowseItemViewController: UIViewController, UITextFieldDelegate {
    
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
        if let address = self.searchField.text {
            let addressUrl = NSURL(string: address)
            if let addressUrl = addressUrl {
                if TWWebPageDownloadManager.defaultDownloadManager.hasLocalCopyOfPage(addressUrl) {
                    return
                }
                TWWebPageDownloadManager.defaultDownloadManager.downloadWebPage(addressUrl, loadResources: false, 
                    completionBlock: {(pageUrl) -> Void in 
                        // TODO: should probably go to sources collection view
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                    }, failureBlock: {(pageUrl, error) -> Void in
                        let bundle:NSBundle? = nil
                        let alertTitle = NSLocalizedString("Download failed", comment: "Web page download failure alert")
                        let alertBody = error?.localizedDescription
                        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
                        var alert = UIAlertController(title: alertTitle, message: alertBody, preferredStyle: UIAlertControllerStyle.Alert)
                        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel, handler: nil)
                        alert.addAction(cancelAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
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
    
    func downloadFailed(downloadUrl: NSURL?, error:NSError?) {
        let bundle:NSBundle? = nil
        let alertTitle = NSLocalizedString("Download failed", comment: "Web page download failure alert")
        let alertBody = error?.localizedDescription
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        var alert = UIAlertController(title: alertTitle, message: alertBody, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func downloadComplete(downloadUrl: NSURL?) {
        // TODO: should probably go to sources collection view
        self.navigationController?.popViewControllerAnimated(true)
    }
}
