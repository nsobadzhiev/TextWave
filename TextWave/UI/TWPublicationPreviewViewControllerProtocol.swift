//
//  TWPublicationPreviewViewControllerProtocol.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 10/1/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import UIKit

protocol TWPublicationPreviewViewControllerDelegate : class {
    func publicationViewController(_ previewController: TWPublicationPreviewViewControllerProtocol, shouldSelectSection index: Int) -> Bool
    func publicationViewController(_ previewController: TWPublicationPreviewViewControllerProtocol, willSelectSection index: Int)
    func publicationViewController(_ previewController: TWPublicationPreviewViewControllerProtocol, didSelectSection index: Int)
}

class TWPublicationPreviewViewControllerProtocol: UIViewController {
    
    init(publicationUrl: URL?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func goToPreviousSection() {
        
    }
    
    func goToNextSection() {
        
    }
    
    func goToSection(_ index: Int) {
        
    }
    
    func goToSection(sectionName: String) {
        
    }

    var previewDelegate: TWPublicationPreviewViewControllerDelegate?
}
