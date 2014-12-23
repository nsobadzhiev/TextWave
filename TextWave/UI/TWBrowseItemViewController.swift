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
        // TODO: start downloading the page.
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

}
