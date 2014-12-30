//
//  TWFileMetadataFactory.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/29/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWFileMetadataFactory {
    
    class func metadataForFile(url: NSURL?) -> TWFileMetadata? {
        let fileType = TWFileTypeManager.fileType(fileUrl: url)
        switch fileType {
        case .EPUB:
            return TWEpubMetadata(url: url)
        case .HTML:
            return TWWebPageMetadata(url: url)
        case .PDF, .Unknown:
            return nil
        }
    }
}