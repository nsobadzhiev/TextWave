//
//  TWEpubPlaybackSource.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 9/29/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWEpubPlaybackSource: TWPlaybackSource {
    
    var epubManager: DMePubManager? = nil
    var epubIterator: DMePubItemIterator? = nil
    
    override var numberOfItems:Int {
        get {
            let numItems = epubIterator?.numberOfItems()
            if let numItems = numItems {
                return Int(numItems)
            }
            else {
                return 0
            }
        }
    }
    
    override init(url: NSURL?) {
        super.init(url: url)
        self.prepareResources()
    }
    
    // prepareResources is intended for making sure all data needed for playback
    // is available. Subclasses should override this method adn load all resources
    override func prepareResources() {
        self.epubManager = DMePubManager(epubPath: self.sourceURL?.absoluteString)
        self.epubIterator = DMePubItemIterator(epubManager: self.epubManager)
        self.title = epubManager?.titleWithError(nil)
        self.subtitle = epubManager?.authorWithError(nil)
    }
    
    override func goToNextItem() -> Bool {
        super.goToNextItem()
        let nextItem = self.epubIterator?.nextObject() as DMePubItem?
        if nextItem != nil {
            self.applyCurrentTextForItem(nextItem)
            return true
        }
        else {
            return false
        }
    }
    
    override func goToPreviousItem() {
        super.goToPreviousItem()
        if let iterator = self.epubIterator {
            let previousItem = iterator.previousItem() as DMePubItem
            self.applyCurrentTextForItem(previousItem)
        }
    }
    
    override func goToItemAtIndex(index: Int) {
        super.goToItemAtIndex(index)
        let unsignedIndex: UInt = UInt(index)
        self.epubIterator?.goToItemWithIndex(unsignedIndex)
        let nextItem = self.epubIterator?.currentItem()
        self.applyCurrentTextForItem(nextItem)
    }
    
    func goToItemWithPath(itemPath: String?) {
        self.epubIterator?.goToItemWithPath(itemPath)
        let nextItem = self.epubIterator?.currentItem()
        self.applyCurrentTextForItem(nextItem)
    }
    
    func applyCurrentTextForItem(epubItem: DMePubItem?) {
        let itemPath = epubItem?.href
        let itemData = self.epubManager?.dataForFileAtPath(itemPath, error: nil)
        if let itemData = itemData {
            let formattedText = NSString(data:itemData, encoding:NSUTF8StringEncoding)
            // extract readable text from the HTML
            let textExtractor = TWTextExtractor()
            self.currentText = textExtractor.extractArticle(htmlString: formattedText)
        }
    }
}