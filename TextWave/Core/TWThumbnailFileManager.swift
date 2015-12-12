//
//  TWThumbnailFileManager.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/29/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWThumbnailFileManager : NSObject, NSCoding {
    
    let catalogEncodeKey = "Thumbnails catalog"
    let thumbnailsFolderName = "Thumbnails"
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var thumbnailsCatalog: Dictionary<String, String>! = nil
    
    var documentsDir:String {
        get {
            let docs = try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.AllDomainsMask, appropriateForURL: nil, create: true)
            return docs.absoluteString
        }
    }
    
    override init() {
        super.init()
        self.loadThumbnailsCatalog()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.thumbnailsCatalog, forKey: catalogEncodeKey)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.thumbnailsCatalog = aDecoder.decodeObjectForKey(self.catalogEncodeKey) as? Dictionary
    }
    
    func cachedThumbnailForUrl(pageUrl:NSURL?) -> UIView? {
        if let pagePath = pageUrl?.lastPathComponent {
            let cachedViewFileName = self.thumbnailsCatalog[pagePath]
            let cacheDir:NSURL? = self.thumbnailsDirectory()
            
            if let cachedViewFileName = cachedViewFileName,
                let cachePath = cacheDir?.URLByAppendingPathComponent(cachedViewFileName) {
                return self.imageViewFromUrl(cachePath)
            }
        }
        return nil
    }
    
    func saveThumbnail(thumbnail:UIImage?, forUrl itemPath:NSURL?) -> Bool {
        if let itemPath = itemPath {
            if let thumbnail = thumbnail { 
                let thumbnailData = UIImagePNGRepresentation(thumbnail)
                let thumbnailsDir = self.thumbnailsDirectory()
                let thumbnailName  = itemPath.lastPathComponent
                let thumbnailSaveUrl = thumbnailsDir?.URLByAppendingPathComponent(thumbnailName!, isDirectory: false)
                if let thumbnailSaveUrl = thumbnailSaveUrl {
                    do {
                        try thumbnailData?.writeToURL(thumbnailSaveUrl, options: NSDataWritingOptions())
                    }
                    catch {
                        // TODO:
                    }
                    self.thumbnailsCatalog[itemPath.lastPathComponent!] = thumbnailSaveUrl.lastPathComponent
                    self.saveThumbnailsCatalog()
                    return true
                }
            }
        }
        return false
    }
    
    func imageViewFromUrl(imageUrl:NSURL?) -> UIImageView? {
        if var imagePath = imageUrl?.path {
            let range = Range<String.Index>(start: imagePath.startIndex, end: imagePath.endIndex)
            imagePath = imagePath.stringByReplacingOccurrencesOfString("/file:", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: range)
            let imageData = NSData(contentsOfFile: imagePath)
            if let imageData = imageData {
                let image = UIImage(data: imageData)
                let imageView = UIImageView(image: image)
                return imageView
            }
        }
        return nil
    }
    
    func thumbnailsDirectory() -> NSURL? {
        let cacheDirectory = try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: NSSearchPathDomainMask.AllDomainsMask, appropriateForURL: nil, create: true)
        let thumbnailsDirectory = cacheDirectory//?.URLByAppendingPathComponent(self.thumbnailsFolderName)
            if NSFileManager.defaultManager().fileExistsAtPath(thumbnailsDirectory.absoluteString) == false {
                let fileManager:NSFileManager = NSFileManager.defaultManager()
                do {
                    try NSFileManager.defaultManager().contentsOfDirectoryAtURL(thumbnailsDirectory, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
                }
                catch {
                    try! fileManager.createDirectoryAtPath(thumbnailsDirectory.absoluteString, withIntermediateDirectories: true, attributes: nil)
                }
                
                
            }
            return thumbnailsDirectory
    }
    
    // MARK: NSUserDefaults
    
    func saveThumbnailsCatalog() {
        userDefaults.setObject(self.thumbnailsCatalog, forKey: self.catalogEncodeKey)
    }
    
    func loadThumbnailsCatalog() {
        self.thumbnailsCatalog = userDefaults.objectForKey(self.catalogEncodeKey) as? Dictionary
        if self.thumbnailsCatalog == nil {
            self.thumbnailsCatalog = Dictionary()
        }
    }
}