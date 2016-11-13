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
    
    override func thumbnailForFileWithBlock(_ completionBlock:@escaping((_ thumbnailView:UIView?) -> Void)) {
        thumbnailManager.thumbnailForWebPage(self.fileUrl, successBlock: {(thumbnailView:UIView) in
            completionBlock(thumbnailView)
            }, failBlock: {(error:Error) in
                completionBlock(nil)
        })
    }
    
    override func thumbnailSize() -> CGSize {
        // TODO: remove diplicate in ThumbnailsManager
        return CGSize(width: 140.0, height: 160.0)
    }
    
    override func titleForFile() -> String? {
        if let url = self.fileUrl {
            let htmlData = try? Data(contentsOf: url as URL)
            let htmlParser = TFHpple(htmlData: htmlData)
            let titleElement = htmlParser?.peekAtSearch(withXPathQuery: "/html/head/title")
            let titleString = titleElement?.text()
            return self.trimWhiteSpaceFromTitle(titleString)
        }
        else {
            return nil
        }
    }
    
    override func authorForFile() -> String? {
        return self.fileUrl?.host
    }
    
    func trimWhiteSpaceFromTitle(_ title:String?) -> String? {
        return title?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
