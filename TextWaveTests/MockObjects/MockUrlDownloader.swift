//
//  MockUrlDownloader.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/18/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class MockUrlDownloader : UrlDownloader {
    var shouldSimulateCompletion: Bool = false
    var shouldSimulateFailure: Bool = false
    
    override func createAndStartRequest() {
        
    }
    
    override func downloadResource() {
        if (self.shouldSimulateCompletion) {
            self.connectionDidFinishLoading(nil)
        }
        else if (self.shouldSimulateFailure) {
            self.connection(nil, didFailWithError: nil)
        }
    }
}
