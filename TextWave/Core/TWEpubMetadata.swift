//
//  TWEpubMetadata.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWEpubMetadata : TWFileMetadata {
    
    let epubManager: DMePubManager? = nil
    
    override init(url: NSURL?) {
        super.init(url: url)
        epubManager = DMePubManager(epubPath: url?.absoluteString)
    }
    override func thumbnailForFile() -> UIImage? {
        return epubManager?.coverWithError(nil)
    }
    
    override func thumbnailForFileWithBlock(completionBlock:((thumbnailView:UIView?) -> Void)) {
        let thumbnail = epubManager?.coverWithError(nil)
        let thumbnailView = UIImageView(image: thumbnail)
        completionBlock(thumbnailView: thumbnailView)
    }
    
    override func thumbnailSize() -> CGSize {
        let cover = self.thumbnailForFile()
        if let cover = cover {
            return CGSizeMake(cover.size.width, cover.size.height)
        }
        else {
            return CGSizeZero
        }
    }
    
    override func titleForFile() -> String? {
        return epubManager?.titleWithError(nil)
    }
    
    override func authorForFile() -> String? {
        return epubManager?.authorWithError(nil)
    }
}