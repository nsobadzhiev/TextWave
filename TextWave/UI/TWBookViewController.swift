//
//  TWBookViewController.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/21/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWBookViewController : TWPublicationPreviewViewControllerProtocol {
    
    @IBOutlet var previewView: UIView! = nil
    
    var bookUrl: URL? {
        didSet{
            self.setup()
        }
    }
    
    var epubPageController: DMePubPageViewController? = nil
    var delegate: TWPublicationPreviewViewControllerDelegate? = nil
    
    required override init(publicationUrl bookUrl: URL?) {
        super.init(publicationUrl: bookUrl)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    func setup() {
        let epubManager = DMePubManager(epubPath: bookUrl?.absoluteString)
        epubPageController = DMePubPageViewController(epubManager: epubManager)
    }
    
    override func viewDidLoad() {
        // add the epub page view controller as child
        self.addChildViewController(epubPageController!)
        epubPageController?.view.frame = CGRect(x: 0.0, y: 0.0, width: self.previewView.frame.size.width, height: self.previewView.frame.size.height)
        self.previewView.addSubview(epubPageController!.view)
        epubPageController?.didMove(toParentViewController: self)
        epubPageController?.loadSystemBookmarkPosition()
    }
    
    override func goToPreviousSection() {
        
    }
    
    override func goToNextSection() {
        
    }
    
    override func goToSection(_ index: Int) {
        if let epubController = self.epubPageController {
            epubController.selectedIndex = UInt(index)
        }
    }
    
    override func goToSection(sectionName: String) {
        if let epubController = self.epubPageController {
            epubController.selectedItem = sectionName
        }
    }
    
    func setBookAndPosition(_ bookUrl: URL?, selectedItem: String?) {
        self.bookUrl = bookUrl
        if (selectedItem != nil) {
            if let epubController = self.epubPageController {
                epubController.selectedItem = selectedItem
            }
        }
    }
    
    func notifyDelegateWillSelect(_ index: Int) {
        self.delegate!.publicationViewController(self, willSelectSection: index)
    }
    
    func notifyDelegateDidSelect(_ index: Int) {
        self.delegate!.publicationViewController(self, didSelectSection: index)
    }
    
    func askDelegateShouldSelectIndex(_ index: Int) -> Bool {
        var shouldAllow = true;
        shouldAllow = self.delegate!.publicationViewController(self, shouldSelectSection: index)
        return shouldAllow;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListenBookSegue" {
            TWNowPlayingManager.instance.startPlaybackWithUrl(self.bookUrl, selectedItem: self.epubPageController?.selectedItem as NSString?)
            let nowPlayingController = segue.destination as? TWNowPlayingViewController
            nowPlayingController?.nowPlayingManager = TWNowPlayingManager.instance
        }
    }
}
