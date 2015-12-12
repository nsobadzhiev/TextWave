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
    
    class func fileType(fileUrl fileUrl:NSURL?) -> TWFileType {
        let fileTypesDict = ["epub": TWFileType.EPUB, "html": TWFileType.HTML, "htm": TWFileType.HTML, "pdf": TWFileType.PDF]
//        let fileExtension = fileUrl?.pathExtension
//        if let fileExtension = fileExtension {
//            let fileType = fileTypesDict[fileExtension]
//            if let fileType = fileType {
//                return fileType
//            }
//        }
        let filePath = fileUrl?.absoluteString
        for (formatExtension, fileType) in fileTypesDict {
            if (filePath?.hasSuffix(formatExtension) == true) {
                return fileType
            }
        }
        return TWFileType.Unknown
    }
}