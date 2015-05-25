//
//  TWBookmarkCell.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 5/25/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWBookmarkCell : UITableViewCell {
    @IBOutlet var thumbnail:UIWebView! = nil
    @IBOutlet var titleLabel:UILabel! = nil
    @IBOutlet var pageNumberLabel:UILabel! = nil
    
    var title:String? {
        get {
            return titleLabel.text;
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var pageNumber:Int {
        get {
            if let pageNum = pageNumberLabel.text?.toInt() {
                return pageNum
            }
            else {
                return 0
            }
        }
        set {
            pageNumberLabel.text = String(stringInterpolation: "\(newValue)")
        }
    }
    
    var thumbnailHtmlString:String {
        get {
            return ""
        }
        set {
            self.loadThumbnailWithString(newValue, baseUrl: nil)   // TODO: set proper base url
        }
    }
    
    var thumbnailUrl:NSURL? {
        get {
            return nil
        }
        set {
            if let url = newValue {
                let request = NSURLRequest(URL: url)
                self.thumbnail.loadRequest(request)
            }
        }
    }
    
    func loadThumbnailWithString(htmlString:String?, baseUrl:NSURL?) {
        self.thumbnail.loadHTMLString(htmlString, baseURL: baseUrl)
    }
}