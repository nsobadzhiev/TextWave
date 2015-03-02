//
//  TWFileMetadata.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/23/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import UIKit

let defaultThumbnailImageName = "defaultCover.png"

class TWFileMetadata {
    let fileUrl:NSURL? = nil
    
    init(url: NSURL?) {
        self.fileUrl = url
    }
    
    func thumbnailForFile() -> UIImage? {
        return UIImage(named: defaultThumbnailImageName)
    }
    
    func thumbnailForFileWithBlock(completionBlock:((thumbnailView:UIView?) -> Void)) {
        let defaultImage = UIImage(named: defaultThumbnailImageName)
        let defaultImageView = UIImageView(image: defaultImage)
        completionBlock(thumbnailView: defaultImageView)
    }
    
    func thumbnailSize() -> CGSize {
        return UIImage(named: defaultThumbnailImageName)!.size
    }
    
    func titleForFile() -> String? {
        return self.fileUrl?.lastPathComponent
    }
    
    func authorForFile() -> String? {
        return nil
    }
}