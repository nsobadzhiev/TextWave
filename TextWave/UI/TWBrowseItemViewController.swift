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
//    var webPageDownloader:TWWebPageDownloader? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @IBAction func didSelectDownloadButton(_ buttonItem: UIBarButtonItem) {
        if let address = self.searchField.text {
            let addressUrl = URL(string: address)
            if let addressUrl = addressUrl {
                if TWWebPageDownloadManager.defaultDownloadManager.hasLocalCopyOfPage(addressUrl) {
                    return
                }
                TWWebPageDownloadManager.defaultDownloadManager.downloadWebPage(addressUrl, loadResources: false, 
                    completionBlock: {(pageUrl) -> Void in 
                        // TODO: should probably go to sources collection view
                        _ = self.navigationController?.popViewController(animated: true)
                        return
                    }, failureBlock: {(pageUrl, error) -> Void in
                        let alertTitle = NSLocalizedString("Download failed", comment: "Web page download failure alert")
                        let alertBody = error?.localizedDescription
                        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
                        let alert = UIAlertController(title: alertTitle, message: alertBody, preferredStyle: UIAlertControllerStyle.alert)
                        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.cancel, handler: nil)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                    })
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, let url = URL(string: text) {
            let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
            self.webView.loadRequest(request)
        }
        
        return true
    }

    // MARK: - TWWebPageDownloaderDelegate
    
    func downloadFailed(_ downloadUrl: URL?, error:NSError?) {
        let alertTitle = NSLocalizedString("Download failed", comment: "Web page download failure alert")
        let alertBody = error?.localizedDescription
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        let alert = UIAlertController(title: alertTitle, message: alertBody, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func downloadComplete(_ downloadUrl: URL?) {
        // TODO: should probably go to sources collection view
        _ = self.navigationController?.popViewController(animated: true)
    }
}
