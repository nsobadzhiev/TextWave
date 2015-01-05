//
//  TWFileMetadata.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWFileMetadata {
    let fileUrl:NSURL? = nil
    
    init(url: NSURL?) {
        self.fileUrl = url
    }
    
    func thumbnailForFile() -> UIImage? {
        return nil
    }
    
    func thumbnailForFileWithBlock(completionBlock:((thumbnailView:UIView?) -> Void)) {
        completionBlock(thumbnailView: nil)
    }
    
    func thumbnailSize() -> CGSize {
        return CGSizeZero
    }
    
    func titleForFile() -> String? {
        return self.fileUrl?.lastPathComponent
    }
}