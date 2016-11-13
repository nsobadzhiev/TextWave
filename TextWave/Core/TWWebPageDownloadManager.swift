//
//  TWWebPageDownloadManager.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 3/21/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

let defaultManager = TWWebPageDownloadManager()

class TWWebPageDownloadManager : TWWebPageDownloaderDelegate {
    var catalogue: Dictionary<String, URL> = Dictionary<String, URL>()
    let catalogueName = "WebPagesCatalogue"
    var pageCompletionCallbacksDict = Dictionary<URL, (_ pageUrl:URL) -> Void>()
    var pageFailureCallbacksDict = Dictionary<URL, (_ pageUrl:URL?, _ error:NSError?) -> Void>()
    
    class var defaultDownloadManager:TWWebPageDownloadManager {
        get {
            return defaultManager
        }
    }
    
    func downloadWebPage(_ pageUrl:URL?, loadResources:Bool, completionBlock:@escaping (_ pageUrl:URL) -> Void, failureBlock:@escaping ((_ pageUrl:URL?, _ error:NSError?) -> Void)) {
        if let pageUrl = pageUrl {
            let downloader = self.downloaderForUrl(pageUrl, loadResources: loadResources)
            let downloadPath = downloader.downloadPathForWebPage()
            if let downloadPath = downloadPath {
                let downloadUrl = URL(fileURLWithPath: downloadPath)
                let downloadName = downloadUrl.lastPathComponent
                self.addCatalogueEntry(downloadName, baseUrl: pageUrl)
                downloader.delegate = self
                self.pageCompletionCallbacksDict[pageUrl] = completionBlock
                self.pageFailureCallbacksDict[pageUrl] = failureBlock
                downloader.startDownload()
                return
            }
        }
        failureBlock(pageUrl, nil)
    }
    
    func addCatalogueEntry(_ pageName:String, baseUrl:URL) {
        self.catalogue[pageName] = baseUrl
    }
    
    func removeCatalogueEntry(_ pageName:String) {
        self.catalogue[pageName] = nil
    }
    
    func baseUrlForWebPage(_ pageName:String?) -> URL? {
        if let pageName = pageName {
            return self.catalogue[pageName]
        }
        else {
            return nil
        }
    }
    
    func hasLocalCopyOfPage(_ pageUrl:URL?) -> Bool {
        for (_, remoteUrl) in self.catalogue {
            if remoteUrl == pageUrl {
                return true
            }
        }
        return false
    }
    
    func cataloguePath() -> String {
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString
        let cataloguePath = cachesPath.appendingPathComponent(catalogueName)
        return cataloguePath
    }
    
    func saveCatalogue() -> Bool {
        let cataloguePath = self.cataloguePath()
        let catalogueData = NSKeyedArchiver.archivedData(withRootObject: self.catalogue)
        try? catalogueData.write(to: URL(fileURLWithPath: cataloguePath), options: [])
        return true
    }
    
    func loadCatalogue() -> Bool {
        let loadedCatalogue:Dictionary<String, URL>? = NSKeyedUnarchiver.unarchiveObject(withFile: self.cataloguePath()) as? Dictionary
        if let loadedCatalogue = loadedCatalogue {
            self.catalogue = loadedCatalogue
            return true
        }
        else {
            return false
        }
    }
    
    func downloaderForUrl(_ pageUrl:URL?, loadResources shouldLoadResources:Bool) -> TWWebPageDownloaderBase {
        assert(shouldLoadResources == false, "Loading whole web pages is not supported")
        return TWHtmlFileDownloader(url: pageUrl)
    }
    
    func failureCallbackForUrl(_ pageUrl:URL) -> ((_ pageUrl:URL?, _ error:NSError?) -> Void)? {
        return self.pageFailureCallbacksDict[pageUrl]
    }
    
    func completionCallbackForUrl(_ pageUrl:URL) -> ((_ pageUrl:URL) -> Void)? {
        return self.pageCompletionCallbacksDict[pageUrl]
    }
    
    // MARK: TWWebPageDownloaderDelegate
    
    func downloadComplete(_ downloader:TWWebPageDownloaderBase) {
        if let url = downloader.webPageUrl {
            if let completionBlock = self.completionCallbackForUrl(url as URL) {
                completionBlock(url as URL)
            }
        }
    }
    
    func downloadFailed(_ downloader:TWWebPageDownloaderBase) {
        if let url = downloader.webPageUrl {
            if let failureBlock = self.failureCallbackForUrl(url as URL) {
                failureBlock(downloader.webPageUrl as URL?, downloader.downloadError)
            }
        }
    }
}
