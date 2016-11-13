//
//  TWFileMetadataFactory.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/29/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWFileMetadataFactory {
    
    class func metadataForFile(_ url: URL?) -> TWFileMetadata? {
        let fileType = TWFileTypeManager.fileType(fileUrl: url)
        switch fileType {
        case .epub:
            return TWEpubMetadata(url: url)
        case .html:
            return TWWebPageMetadata(url: url)
        case .pdf, .unknown:
            return TWFileMetadata(url: url)
        }
    }
}
