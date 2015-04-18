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
        if let pagePath = pageUrl?.absoluteString {
            let cachedViewPath = self.thumbnailsCatalog[pagePath]
            if let cachePath = cachedViewPath {
                return self.imageViewFromUrl(NSURL(fileURLWithPath: cachePath))
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
                    if let itemPath = itemPath.absoluteString {
                        var writeError:NSError? = nil
                        thumbnailData.writeToURL(thumbnailSaveUrl, options: NSDataWritingOptions.allZeros, error: &writeError)
                        self.thumbnailsCatalog[itemPath] = thumbnailSaveUrl.absoluteString
                        self.saveThumbnailsCatalog()
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func imageViewFromUrl(imageUrl:NSURL?) -> UIImageView? {
        if var imagePath = imageUrl?.path {
            let range = Range<String.Index>(start: imagePath.startIndex, end: imagePath.endIndex)
            imagePath = imagePath.stringByReplacingOccurrencesOfString("/file:", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: range)
            var readError:NSError? = nil
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
        let cacheDirectory = NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: NSSearchPathDomainMask.AllDomainsMask, appropriateForURL: nil, create: true, error: nil)
        let thumbnailsDirectory = cacheDirectory//?.URLByAppendingPathComponent(self.thumbnailsFolderName)
        if let thumbnailsDirectory = thumbnailsDirectory {
            if NSFileManager.defaultManager().fileExistsAtPath(thumbnailsDirectory.absoluteString!) == false {
                var createError:NSError? = nil
                var booleanLiteral = BooleanLiteralType()
                booleanLiteral = false
                let fileManager:NSFileManager = NSFileManager.defaultManager()
                 NSFileManager.defaultManager().contentsOfDirectoryAtURL(thumbnailsDirectory, includingPropertiesForKeys: nil, options: nil, error: nil)
                fileManager.createDirectoryAtPath(thumbnailsDirectory.absoluteString!, withIntermediateDirectories: true, attributes: nil, error: &createError)
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