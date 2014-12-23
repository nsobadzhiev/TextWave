//
//  TWBookViewControllerTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/21/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import XCTest

class TWBookViewControllerTests: XCTestCase, TWBookViewControllerDelegate {
    
    var bookController: TWBookViewController! = TWBookViewController(url:nil)
    var hasAskedDelegateShouldSelect = false
    var hasCalledDelegateWillSelect = false
    var hasCalledDelegateDidSelect = false
    var selectionIndex = -1

    override func setUp() {
        super.setUp()
        bookController.delegate = self;
    }
    
    override func tearDown() {
        bookController = nil
        super.tearDown()
    }
    
    func bookViewController(bookController: TWBookViewController, shouldSelectSection index: Int) -> Bool {
        hasAskedDelegateShouldSelect = true;
        selectionIndex = index;
        return true;
    }
    
    func bookViewController(bookController: TWBookViewController, willSelectSection index: Int) {
        hasCalledDelegateWillSelect = true;
        selectionIndex = index;
    }
    
    func bookViewController(bookController: TWBookViewController, didSelectSection index: Int) {
        hasCalledDelegateDidSelect = true;
        selectionIndex = index;
    }

//    func testSettingDelegate() {
//        let areEqual = (bookController.delegate === self as TWBookViewControllerDelegate)
//        XCTAssertEqualObjects(bookController.delegate as NSObject?, self as NSObject?, "");
//    }
    
    func testNotifyingDelegateWillSelect() {
        let selectedIndex = 3;
        bookController.notifyDelegateWillSelect(selectedIndex)
        XCTAssertEqual(hasCalledDelegateWillSelect, true, "Should call the willSelectSection: delegate method")
        XCTAssertEqual(selectionIndex, selectedIndex, "Should pass the supplied value to the willSelectSection: method")
    }
    
    func testNotifyingDelegateDidSelect() {
        let selectedIndex = 4;
        bookController.notifyDelegateDidSelect(selectedIndex)
        XCTAssertEqual(hasCalledDelegateDidSelect, true, "Should call the didSelectSection: delegate method")
        XCTAssertEqual(selectionIndex, selectedIndex, "Should pass the supplied value to the didSelectSection: method")
    }
    
    func testAskingShouldSelectIndex() {
        XCTAssertEqual(bookController.askDelegateShouldSelectIndex(4), true, "By default any transition should be allowing in the base class")
    }
}
