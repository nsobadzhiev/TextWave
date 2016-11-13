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
//        self.currentItemIndex = 0
    }
    
    override init(url: URL?) {
        super.init(url: url)
        if let suppliedUrl = url {
            do {
                self.currentText = try String(contentsOf: suppliedUrl, encoding: String.Encoding.utf8)
            }
            catch {
                print("Unable to read current text from \(suppliedUrl.absoluteString)")
            }
            
//            self.currentItemIndex = 0
        }
    }
    
    override var numberOfItems:Int {
        get {
            return 1
        }
    }
    
    override func goToNextItem() -> Bool {
        if self.currentItemIndex == -1 {
            self.currentItemIndex = 0
            return true
        }
        else {
            return false
        }
    }
    
    override func goToPreviousItem() {

    }
    
    override func goToItemAtIndex(_ index: Int) {
        
    }
}
