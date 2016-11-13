//
//  TWPublicationPreviewViewControllerFactory.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 10/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import UIKit

class TWPublicationPreviewViewControllerFactory {
    
    // MARK: Publication preview
    
    class func previewViewControllerForUrl(_ url: URL?, selectedItem: String?) -> TWPublicationPreviewViewControllerProtocol? {
        if TWFileTypeManager.fileType(fileUrl: url) == TWFileType.epub {
            return self.createEpubViewController(epubUrl: url, selectedItem: selectedItem)
        }
        else if TWFileTypeManager.fileType(fileUrl: url) == TWFileType.html {
            return self.createWebPageViewController(webPageUrl: url)
        }
        return nil
    }
    
    class func instantiateViewControllerFromStoryboard(_ name:String) -> UIViewController {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryBoard.instantiateViewController(withIdentifier: name) 
    }
    
    class func createEpubViewController(epubUrl url:URL?, selectedItem: String?) -> TWPublicationPreviewViewControllerProtocol {
        let previewController = self.instantiateViewControllerFromStoryboard("BookViewController") as! TWBookViewController
        previewController.setBookAndPosition(url, selectedItem: selectedItem)
        return previewController
    }
    
    class func createWebPageViewController(webPageUrl url:URL?) -> TWPublicationPreviewViewControllerProtocol {
        let previewController = self.instantiateViewControllerFromStoryboard("WebPageViewController") as! TWWebPageViewController
        previewController.pageUrl = url
        return previewController
    }
    
    // MARK: Table of contents
    
    class func supportsTableOfContents(_ url:URL?) -> Bool {
        return (TWFileTypeManager.fileType(fileUrl: url) == TWFileType.epub)
    }
    
    class func tableOfContentsControllerForUrl(_ url:URL?) -> DMTableOfContentsTableViewController? {
        if TWFileTypeManager.fileType(fileUrl: url) == TWFileType.epub {
            if let url = url {
                return DMePubTableOfContentsTableViewController(publicationPath: url.absoluteString)
            }
        }
        return nil
    }
    
}
