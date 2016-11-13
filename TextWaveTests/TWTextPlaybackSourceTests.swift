//
//  TWTextPlaybackSourceTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/13/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import XCTest

class TWTextPlaybackSourceTests: XCTestCase {
    
    var sourceString: String = "Simple text"
    var textSource: TWTextPlaybackSource? = nil

    override func setUp() {
        super.setUp()
        textSource = TWTextPlaybackSource(text: self.sourceString)
    }
    
    override func tearDown() {
        textSource = nil
        super.tearDown()
    }

    func testInitializngWithText() {
        XCTAssertTrue(textSource?.currentText == sourceString, "Initializing a TWTextPlaybackSource with a string should set the same value in the currentText property")
    }
    
    func testItemIndexAtBegining() {
        XCTAssertEqual(textSource!.currentItemIndex, 0, "The current index should be 0 right after the object is initialized")
    }
    
    func testInitializingWithNilUrl() {
        XCTAssertNotNil(TWTextPlaybackSource(url: nil), "Should be able to handle a nil NSURL without raising exception")
    }
    
    func testGoingToNextItemDoesNotIncrementIndex() {
        textSource?.goToNextItem()
        XCTAssertEqual(textSource!.currentItemIndex, 0, "A text source should not be affected by going to the next item - it is only one")
    }
    
    func testGoingToPreviousItemDoesNotDecrementIndex() {
        textSource?.goToPreviousItem()
        XCTAssertEqual(textSource!.currentItemIndex, 0, "A text source should not be affected by going to the previous item - it is only one")
    }
    
    func testGoingToItemAtIndexDoesNotIncrementIndex() {
        textSource?.goToItemAtIndex(5)
        XCTAssertEqual(textSource!.currentItemIndex, 0, "A text source should not be affected by going to an item - it is only one")
    }

}


    

