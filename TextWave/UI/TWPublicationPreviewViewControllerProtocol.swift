//
//  TWPublicationPreviewViewControllerProtocol.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 10/1/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWPublicationPreviewViewControllerDelegate : class {
    func publicationViewController(previewController: TWPublicationPreviewViewControllerProtocol, shouldSelectSection index: Int) -> Bool
    func publicationViewController(previewController: TWPublicationPreviewViewControllerProtocol, willSelectSection index: Int)
    func publicationViewController(previewController: TWPublicationPreviewViewControllerProtocol, didSelectSection index: Int)
}

class TWPublicationPreviewViewControllerProtocol: UIViewController {
    
    init(publicationUrl: NSURL?) {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func goToPreviousSection() {
        
    }
    
    func goToNextSection() {
        
    }
    
    func goToSection(index: Int) {
        
    }

    var previewDelegate: TWPublicationPreviewViewControllerDelegate?
}