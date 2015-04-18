//
//  TWWebPageDownloaderProtocol.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 3/22/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWWebPageDownloaderDelegate {
    func downloadComplete(downloader:TWWebPageDownloaderBase)
    func downloadFailed(downloader:TWWebPageDownloaderBase)
}

class TWWebPageDownloaderBase : NSObject {
    var webPageUrl:NSURL? = nil
    var delegate:TWWebPageDownloaderDelegate? = nil
    var downloading:Bool = false
    var downloadError:NSError? = nil
    
    required init(url:NSURL?) {
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
        var urlDirPath = self.webPageUrl?.lastPathComponent
        let docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as? NSString
        var fullPath = urlHost
        if var fullPath = fullPath {
            if let urlDirPath = urlDirPath {
                if count(urlDirPath.utf16) == 0 {
                    fullPath = fullPath + "-" + urlDirPath
                }
                fullPath = docsDir!.stringByAppendingPathComponent(fullPath)
                if fullPath.hasSuffix(".html") == false &&
                    fullPath.hasSuffix(".htm") == false {
                        fullPath = fullPath + ".html";
                }
                let fullUrl = NSURL(fileURLWithPath: fullPath)
                var createDirError:NSError? = nil
                //NSFileManager.defaultManager().createDirectoryAtURL(fullUrl!, withIntermediateDirectories: true, attributes: nil, error: &createDirError)
                //fullPath = fullPath.stringByAppendingPathExtension("html")!
                let range = Range<String.Index>(start: fullPath.startIndex, end: fullPath.endIndex)
                fullPath = fullPath.stringByReplacingOccurrencesOfString(".", withString: "_", options: NSStringCompareOptions.CaseInsensitiveSearch, range: range)
                return fullPath
            }
        }
        return nil
    }
}