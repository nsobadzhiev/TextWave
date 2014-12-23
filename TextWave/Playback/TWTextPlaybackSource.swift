//
//  TWTextPlaybackSource.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWTextPlaybackSource : TWPlaybackSource {
    
    init(text: String) {
        super.init(url: nil)
        self.currentText = text
        self.currentItemIndex = 0
    }
    
    override init(url: NSURL?) {
        super.init(url: url)
        if let suppliedUrl = url? {
            self.currentText = String(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: nil)
            self.currentItemIndex = 0
        }
    }
    
    override func goToNextItem() {

    }
    
    override func goToPreviousItem() {

    }
    
    override func goToItemAtIndex(index: Int) {
        
    }
}