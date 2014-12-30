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
    
    var thumbnailsCatalog: Dictionary<NSURL, NSURL>! = nil
    
    override init() {
        super.init()
        self.loadThumbnailsCatalog()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.thumbnailsCatalog, forKey: catalogEncodeKey)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.thumbnailsCatalog = aDecoder.decodeObjectForKey(self.catalogEncodeKey) as Dictionary
    }
    
    func cachedThumbnailForUrl(pageUrl:NSURL?) -> UIView? {
        if let pageUrl = pageUrl {
            let cachedViewUrl = self.thumbnailsCatalog[pageUrl]
            return self.imageViewFromUrl(cachedViewUrl)
        }
        else {
            return nil
        }
    }
    
    func saveThumbnail(thumbnail:UIImage?, forUrl itemPath:NSURL?) -> Bool {
        if let itemPath = itemPath {
            if let thumbnail = thumbnail { 
                let thumbnailData = UIImagePNGRepresentation(thumbnail)
                let thumbnailsDir = self.thumbnailsDirectory()
                let thumbnailName  = itemPath.lastPathComponent
                let thumbnailSaveUrl = thumbnailsDir?.URLByAppendingPathComponent(thumbnailName!, isDirectory: false)
                if let thumbnailSaveUrl = thumbnailSaveUrl {
                    thumbnailData.writeToURL(thumbnailSaveUrl, atomically: false)
                    self.thumbnailsCatalog[itemPath] = thumbnailSaveUrl
                    self.saveThumbnailsCatalog()
                    return true
                }
            }
        }
        return false
    }
    
    func imageViewFromUrl(imageUrl:NSURL?) -> UIImageView? {
        if let imageUrl = imageUrl {
            let imageData = NSData(contentsOfURL: imageUrl)
            if let imageData = imageData {
                let image = UIImage(data: imageData)
                let imageView = UIImageView(image: image)
                return imageView
            }
        }
        return nil
    }
    
    func thumbnailsDirectory() -> NSURL? {
        let cacheDirectory = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: NSSearchPathDomainMask.AllDomainsMask, appropriateForURL: nil, create: true, error: nil)
        let thumbnailsDirectory = cacheDirectory?.URLByAppendingPathComponent(self.thumbnailsFolderName)
        if let thumbnailsDirectory = thumbnailsDirectory {
            if NSFileManager.defaultManager().fileExistsAtPath(thumbnailsDirectory.absoluteString!) == false {
                let createError:NSError? = nil
                var booleanLiteral = BooleanLiteralType()
                booleanLiteral = false
                let fileManager:NSFileManager = NSFileManager.defaultManager()
                fileManager.createDirectoryAtPath(thumbnailsDirectory.absoluteString!, withIntermediateDirectories: false, attributes: nil, error: nil)
            }
            return thumbnailsDirectory
        }
        return nil
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