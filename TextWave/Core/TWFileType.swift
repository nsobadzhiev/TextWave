//
//  TWFileType.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 10/30/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

enum TWFileType {
    case Unknown
    case EPUB
    case HTML
    case PDF
}

class TWFileTypeManager {
    
    class func fileType(#fileUrl:NSURL?) -> TWFileType {
        let fileTypesDict = ["epub": TWFileType.EPUB, "html": TWFileType.HTML, "htm": TWFileType.HTML, "pdf": TWFileType.PDF]
        let fileExtension = fileUrl?.pathExtension
        if let fileExtension = fileExtension {
            let fileType = fileTypesDict[fileExtension]
            if let fileType = fileType {
                return fileType
            }
        }
        return TWFileType.Unknown
    }
}