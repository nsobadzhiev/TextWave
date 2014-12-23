//
//  TWPublicationPreviewViewControllerFactory.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 10/19/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWPublicationPreviewViewControllerFactory {
    
    class func previewViewControllerForUrl(url: NSURL?, selectedItem: String?) -> TWPublicationPreviewViewControllerProtocol? {
        if TWFileTypeManager.fileType(fileUrl: url) == TWFileType.EPUB {
            return self.createEpubViewController(epubUrl: url, selectedItem: selectedItem)
        }
        else if TWFileTypeManager.fileType(fileUrl: url) == TWFileType.HTML {
            return self.createWebPageViewController(webPageUrl: url)
        }
        return nil
    }
    
    class func instantiateViewControllerFromStoryboard(name:String) -> UIViewController {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryBoard.instantiateViewControllerWithIdentifier(name) as UIViewController
    }
    
    class func createEpubViewController(epubUrl url:NSURL?, selectedItem: String?) -> TWPublicationPreviewViewControllerProtocol {
        let previewController = self.instantiateViewControllerFromStoryboard("BookViewController") as TWBookViewController
        previewController.setBookAndPosition(url, selectedItem: selectedItem)
        //previewController.showListenButton = false
        return previewController
    }
    
    class func createWebPageViewController(webPageUrl url:NSURL?) -> TWPublicationPreviewViewControllerProtocol {
        let previewController = self.instantiateViewControllerFromStoryboard("WebPageViewController") as TWWebPageViewController
        previewController.pageUrl = url
        return previewController
    }
    
}