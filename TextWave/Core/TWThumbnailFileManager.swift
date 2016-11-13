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
    
    let userDefaults = UserDefaults.standard
    
    var thumbnailsCatalog: Dictionary<String, String>! = nil
    
    var documentsDir:String {
        get {
            let docs = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask, appropriateFor: nil, create: true)
            return docs.absoluteString
        }
    }
    
    override init() {
        super.init()
        self.loadThumbnailsCatalog()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.thumbnailsCatalog, forKey: catalogEncodeKey)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.thumbnailsCatalog = aDecoder.decodeObject(forKey: self.catalogEncodeKey) as? Dictionary
    }
    
    func cachedThumbnailForUrl(_ pageUrl:URL?) -> UIView? {
        if let pagePath = pageUrl?.lastPathComponent {
            let cachedViewFileName = self.thumbnailsCatalog[pagePath]
            let cacheDir:URL? = self.thumbnailsDirectory()
            
            if let cachedViewFileName = cachedViewFileName,
                let cachePath = cacheDir?.appendingPathComponent(cachedViewFileName) {
                return self.imageViewFromUrl(cachePath)
            }
        }
        return nil
    }
    
    func saveThumbnail(_ thumbnail:UIImage?, forUrl itemPath:URL?) -> Bool {
        if let itemPath = itemPath {
            if let thumbnail = thumbnail { 
                let thumbnailData = UIImagePNGRepresentation(thumbnail)
                let thumbnailsDir = self.thumbnailsDirectory()
                let thumbnailName  = itemPath.lastPathComponent
                let thumbnailSaveUrl = thumbnailsDir?.appendingPathComponent(thumbnailName, isDirectory: false)
                if let thumbnailSaveUrl = thumbnailSaveUrl {
                    do {
                        try thumbnailData?.write(to: thumbnailSaveUrl, options: NSData.WritingOptions())
                    }
                    catch {
                        // TODO:
                    }
                    self.thumbnailsCatalog[itemPath.lastPathComponent] = thumbnailSaveUrl.lastPathComponent
                    self.saveThumbnailsCatalog()
                    return true
                }
            }
        }
        return false
    }
    
    func imageViewFromUrl(_ imageUrl:URL?) -> UIImageView? {
        if var imagePath = imageUrl?.path {
            let range:Range<String.Index> = Range(uncheckedBounds: (imagePath.startIndex, imagePath.endIndex))
            imagePath = imagePath.replacingOccurrences(of: "/file:", with: "", options: NSString.CompareOptions.caseInsensitive, range: range)
            let imageData = try? Data(contentsOf: URL(fileURLWithPath: imagePath))
            if let imageData = imageData {
                let image = UIImage(data: imageData)
                let imageView = UIImageView(image: image)
                return imageView
            }
        }
        return nil
    }
    
    func thumbnailsDirectory() -> URL? {
        let cacheDirectory = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.allDomainsMask, appropriateFor: nil, create: true)
        let thumbnailsDirectory = cacheDirectory//?.URLByAppendingPathComponent(self.thumbnailsFolderName)
            if FileManager.default.fileExists(atPath: thumbnailsDirectory.absoluteString) == false {
                let fileManager:FileManager = FileManager.default
                do {
                    try FileManager.default.contentsOfDirectory(at: thumbnailsDirectory, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
                }
                catch {
                    try! fileManager.createDirectory(atPath: thumbnailsDirectory.absoluteString, withIntermediateDirectories: true, attributes: nil)
                }
                
                
            }
            return thumbnailsDirectory
    }
    
    // MARK: NSUserDefaults
    
    func saveThumbnailsCatalog() {
        userDefaults.set(self.thumbnailsCatalog, forKey: self.catalogEncodeKey)
    }
    
    func loadThumbnailsCatalog() {
        self.thumbnailsCatalog = userDefaults.object(forKey: self.catalogEncodeKey) as? Dictionary
        if self.thumbnailsCatalog == nil {
            self.thumbnailsCatalog = Dictionary()
        }
    }
}
