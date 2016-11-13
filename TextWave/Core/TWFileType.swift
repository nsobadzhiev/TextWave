//
//  TWFileType.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 10/30/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

enum TWFileType {
    case unknown
    case epub
    case html
    case pdf
}

class TWFileTypeManager {
    
    class func fileType(fileUrl:URL?) -> TWFileType {
        let fileTypesDict = ["epub": TWFileType.epub, "html": TWFileType.html, "htm": TWFileType.html, "pdf": TWFileType.pdf]
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
        return TWFileType.unknown
    }
}
