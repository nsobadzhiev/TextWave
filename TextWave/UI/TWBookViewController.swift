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
    
    var bookUrl: NSURL? {
        didSet{
            self.setup()
        }
    }
    
    var epubPageController: DMePubPageViewController? = nil
    var delegate: TWPublicationPreviewViewControllerDelegate? = nil
    
    required override init(publicationUrl bookUrl: NSURL?) {
        super.init(publicationUrl: bookUrl)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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
        epubPageController?.view.frame = CGRectMake(0.0, 0.0, self.previewView.frame.size.width, self.previewView.frame.size.height)
        self.previewView.addSubview(epubPageController!.view)
        epubPageController?.didMoveToParentViewController(self)
        epubPageController?.loadSystemBookmarkPosition()
    }
    
    override func goToPreviousSection() {
        
    }
    
    override func goToNextSection() {
        
    }
    
    override func goToSection(index: Int) {
        if let epubController = self.epubPageController {
            epubController.selectedIndex = UInt(index)
        }
    }
    
    override func goToSection(#sectionName: String) {
        if let epubController = self.epubPageController {
            epubController.selectedItem = sectionName
        }
    }
    
    func setBookAndPosition(bookUrl: NSURL?, selectedItem: String?) {
        self.bookUrl = bookUrl
        if (selectedItem != nil) {
            if let epubController = self.epubPageController {
                epubController.selectedItem = selectedItem
            }
        }
    }
    
    func notifyDelegateWillSelect(index: Int) {
        self.delegate!.publicationViewController(self, willSelectSection: index)
    }
    
    func notifyDelegateDidSelect(index: Int) {
        self.delegate!.publicationViewController(self, didSelectSection: index)
    }
    
    func askDelegateShouldSelectIndex(index: Int) -> Bool {
        var shouldAllow = true;
        shouldAllow = self.delegate!.publicationViewController(self, shouldSelectSection: index)
        return shouldAllow;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ListenBookSegue" {
            TWNowPlayingManager.instance.startPlaybackWithUrl(self.bookUrl, selectedItem: self.epubPageController?.selectedItem)
            let nowPlayingController = segue.destinationViewController as? TWNowPlayingViewController
            nowPlayingController?.nowPlayingManager = TWNowPlayingManager.instance
        }
    }
}
