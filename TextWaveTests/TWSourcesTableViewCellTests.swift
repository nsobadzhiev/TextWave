//
//  TWSourcesTableViewCellTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/9/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWSourcesTableViewCellTests: XCTestCase, TWSourcesTableViewCellDelegate {
    
    var sourceCell: TWSourcesTableViewCell? = nil
    var selectedCellIndex: Int = 0

    override func setUp() {
        super.setUp()
        sourceCell = TWSourcesTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        sourceCell!.delegate = self
        selectedCellIndex = 0
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func sourcesCell(cell: TWSourcesTableViewCell, didSelectItemAtIndex index: Int) {
        selectedCellIndex = index;
    }

//    func testAbilityToSetFirstSourceTitle() {
//        let testTitle = "test"
//        sourceCell!.title1 = testTitle
//        XCTAssertEqualObjects(sourceCell!.title1, testTitle, "Should be able to set the title of the first button")
//    }
//
//    func testAbilityToSetSecondSourceTitle() {
//        let testTitle = "test"
//        sourceCell!.title2 = testTitle
//        XCTAssertEqualObjects(sourceCell!.title2, testTitle, "Should be able to set the title of the second button")
//    }
//    
//    func testAbilityToSetThirdSourceTitle() {
//        let testTitle = "test"
//        sourceCell!.title3 = testTitle
//        XCTAssertEqualObjects(sourceCell!.title3, testTitle, "Should be able to set the title of the third button")
//    }
//    
//    func testAbilityToSetFirstSourceImage() {
//        let testImage = UIImage()
//        sourceCell!.image1 = testImage
//        XCTAssertEqualObjects(sourceCell!.image1, testImage, "Should be able to set the image of the first source")
//    }
//    
//    func testAbilityToSetSecondSourceImage() {
//        let testImage = UIImage()
//        sourceCell!.image2 = testImage
//        XCTAssertEqualObjects(sourceCell!.image2, testImage, "Should be able to set the image of the second source")
//    }
//    
//    func testAbilityToSetThirdSourceImage() {
//        let testImage = UIImage()
//        sourceCell!.image3 = testImage
//        XCTAssertEqualObjects(sourceCell!.image3, testImage, "Should be able to set the image of the third source")
//    }
//    
//    func testSelectingTheFirstItem() {
//        sourceCell!.onButton1Tap(UIButton())
//        XCTAssertEqual(selectedCellIndex, 0, "The button target should call the delegate method with a selected index equal to 1");
//    }
//    
//    func testSelectingTheSecondItem() {
//        sourceCell!.onButton2Tap(UIButton())
//        XCTAssertEqual(selectedCellIndex, 1, "The button target should call the delegate method with a selected index equal to 2");
//    }
//    
//    func testSelectingTheThirdItem() {
//        sourceCell!.onButton3Tap(UIButton())
//        XCTAssertEqual(selectedCellIndex, 2, "The button target should call the delegate method with a selected index equal to 3");
//    }
}
