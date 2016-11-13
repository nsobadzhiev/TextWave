//
//  TWWebPageDownloaderProtocol.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 3/22/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWWebPageDownloaderDelegate {
    func downloadComplete(_ downloader:TWWebPageDownloaderBase)
    func downloadFailed(_ downloader:TWWebPageDownloaderBase)
}

class TWWebPageDownloaderBase : NSObject {
    var webPageUrl:URL? = nil
    var delegate:TWWebPageDownloaderDelegate? = nil
    var downloading:Bool = false
    var downloadError:NSError? = nil
    
    required init(url:URL?) {
        webPageUrl = url
    }
    
    func startDownload() {
        assertionFailure("Shouldn't use the TWWebPageDownloader base class directly")
    }
    
    func stopDownload() {
        assertionFailure("Shouldn't use the TWWebPageDownloader base class directly")
    }
    
    func downloadPathForWebPage() -> String? {
        // form the directory name by concatenating host name and directory path
        let urlHost = self.webPageUrl?.host
        let urlDirPath = self.webPageUrl?.lastPathComponent
        let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fullPath = urlHost
        if var fullPath = fullPath {
            if let urlDirPath = urlDirPath {
                if urlDirPath.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                    fullPath = fullPath + "-" + urlDirPath
                }
                fullPath = docsDir.appendingPathComponent(fullPath)
                if fullPath.hasSuffix(".html") == false &&
                    fullPath.hasSuffix(".htm") == false {
                        fullPath = fullPath + ".html";
                }
                let range = Range(uncheckedBounds: (fullPath.startIndex, fullPath.endIndex))
                fullPath = fullPath.replacingOccurrences(of: ".", with: "_", options: NSString.CompareOptions.caseInsensitive, range: range)
                return fullPath
            }
        }
        return nil
    }
}
