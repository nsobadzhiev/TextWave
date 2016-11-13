//
//  TWEpubMetadata.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import UIKit

class TWEpubMetadata : TWFileMetadata {
    
    var epubManager: DMePubManager? = nil
    
    override init(url: URL?) {
        super.init(url: url)
        epubManager = DMePubManager(epubPath: url?.absoluteString)
    }
    override func thumbnailForFile() -> UIImage? {
        var thumbnail:UIImage? = nil
        do {
            try thumbnail = epubManager?.cover();
        }
        catch {
            
        }
        return thumbnail
    }
    
    override func thumbnailForFileWithBlock(_ completionBlock:@escaping ((_ thumbnailView:UIView?) -> Void)) {
        var thumbnail:UIImage? = nil
        do {
            try thumbnail = epubManager?.cover();
        }
        catch {
            
        }
        let thumbnailView = UIImageView(image: thumbnail)
        completionBlock(thumbnailView)
    }
    
    override func thumbnailSize() -> CGSize {
        let cover = self.thumbnailForFile()
        if let cover = cover {
            return CGSize(width: cover.size.width, height: cover.size.height)
        }
        else {
            return CGSize.zero
        }
    }
    
    override func titleForFile() -> String? {
        return try? epubManager!.title()
    }
    
    override func authorForFile() -> String? {
        return try? epubManager!.author()
    }
}
