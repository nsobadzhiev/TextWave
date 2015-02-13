//
//  TWWebPageMetadata.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWWebPageMetadata : TWFileMetadata {
    
    let thumbnailManager = TWWebPageThumbnailManager()
    
    override func thumbnailForFile() -> UIImage? {
        return nil
    }
    
    override func thumbnailForFileWithBlock(completionBlock:((thumbnailView:UIView?) -> Void)) {
        thumbnailManager.thumbnailForWebPage(self.fileUrl, successBlock: {(thumbnailView:UIView) in
            completionBlock(thumbnailView: thumbnailView)
            }, failBlock: {(error:NSError?) in
                completionBlock(thumbnailView: nil)
        })
    }
    
    override func thumbnailSize() -> CGSize {
        // TODO: remove diplicate in ThumbnailsManager
        return CGSizeMake(140.0, 160.0)
    }
    
    override func titleForFile() -> String? {
        if let url = self.fileUrl {
            let htmlData = NSData(contentsOfURL: url)
            let htmlParser = TFHpple(HTMLData: htmlData)
            let titleElement = htmlParser.peekAtSearchWithXPathQuery("/html/head/title")
            let titleString = titleElement.text()
            return titleString
        }
        else {
            return nil
        }
    }
    
    override func authorForFile() -> String? {
        return self.fileUrl?.host
    }
}