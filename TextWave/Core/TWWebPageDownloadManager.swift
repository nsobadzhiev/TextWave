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
    var catalogue: Dictionary<String, NSURL> = Dictionary<String, NSURL>()
    let catalogueName = "WebPagesCatalogue"
    var pageCompletionCallbacksDict = Dictionary<NSURL, (pageUrl:NSURL) -> Void>()
    var pageFailureCallbacksDict = Dictionary<NSURL, (pageUrl:NSURL?, error:NSError?) -> Void>()
    
    class var defaultDownloadManager:TWWebPageDownloadManager {
        get {
            return defaultManager
        }
    }
    
    func downloadWebPage(pageUrl:NSURL?, loadResources:Bool, completionBlock:(pageUrl:NSURL) -> Void, failureBlock:((pageUrl:NSURL?, error:NSError?) -> Void)) {
        if let pageUrl = pageUrl {
            let downloader = self.downloaderForUrl(pageUrl, loadResources: loadResources)
            let downloadPath = downloader.downloadPathForWebPage()
            if let downloadPath = downloadPath {
                let downloadUrl = NSURL(fileURLWithPath: downloadPath)
                if let downloadName = downloadUrl?.lastPathComponent {
                    self.addCatalogueEntry(downloadName, baseUrl: pageUrl)
                    downloader.delegate = self
                    self.pageCompletionCallbacksDict[pageUrl] = completionBlock
                    self.pageFailureCallbacksDict[pageUrl] = failureBlock
                    downloader.startDownload()
                    return
                }
            }
        }
        failureBlock(pageUrl: pageUrl, error: nil)
    }
    
    func addCatalogueEntry(pageName:String, baseUrl:NSURL) {
        self.catalogue[pageName] = baseUrl
    }
    
    func removeCatalogueEntry(pageName:String) {
        self.catalogue[pageName] = nil
    }
    
    func baseUrlForWebPage(pageName:String?) -> NSURL? {
        if let pageName = pageName {
            return self.catalogue[pageName]
        }
        else {
            return nil
        }
    }
    
    func hasLocalCopyOfPage(pageUrl:NSURL?) -> Bool {
        for (localLocation, remoteUrl) in self.catalogue {
            if remoteUrl.isEqual(pageUrl) {
                return true
            }
        }
        return false
    }
    
    func cataloguePath() -> String {
        let cachesPath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as NSString
        let cataloguePath = cachesPath.stringByAppendingPathComponent(catalogueName)
        return cataloguePath
    }
    
    func saveCatalogue() -> Bool {
        let cataloguePath = self.cataloguePath()
        let catalogueData = NSKeyedArchiver.archivedDataWithRootObject(self.catalogue)
        catalogueData.writeToFile(cataloguePath, atomically: false)
        return true
    }
    
    func loadCatalogue() -> Bool {
        let loadedCatalogue:Dictionary<String, NSURL>? = NSKeyedUnarchiver.unarchiveObjectWithFile(self.cataloguePath()) as? Dictionary
        if let loadedCatalogue = loadedCatalogue {
            self.catalogue = loadedCatalogue
            return true
        }
        else {
            return false
        }
    }
    
    func downloaderForUrl(pageUrl:NSURL?, loadResources shouldLoadResources:Bool) -> TWWebPageDownloaderBase {
        if shouldLoadResources {
            return TWWebPageDownloader(url: pageUrl)
        }
        else {
            return TWHtmlFileDownloader(url: pageUrl)
        }
    }
    
    func failureCallbackForUrl(pageUrl:NSURL) -> ((pageUrl:NSURL?, error:NSError?) -> Void)? {
        return self.pageFailureCallbacksDict[pageUrl]
    }
    
    func completionCallbackForUrl(pageUrl:NSURL) -> ((pageUrl:NSURL) -> Void)? {
        return self.pageCompletionCallbacksDict[pageUrl]
    }
    
    // MARK: TWWebPageDownloaderDelegate
    
    func downloadComplete(downloader:TWWebPageDownloaderBase) {
        if let url = downloader.webPageUrl {
            if let completionBlock = self.completionCallbackForUrl(url) {
                completionBlock(pageUrl:url)
            }
        }
    }
    
    func downloadFailed(downloader:TWWebPageDownloaderBase) {
        if let url = downloader.webPageUrl {
            if let failureBlock = self.failureCallbackForUrl(url) {
                failureBlock(pageUrl:downloader.webPageUrl, error:downloader.downloadError)
            }
        }
    }
}