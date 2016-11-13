    //
//  TWSourcesTableViewControllerTests.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/9/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWSourcesTableViewControllerTests: XCTestCase {
    
    let fileSystemManager = TWTestableFileSystemManager()
    let fileManager = TWDocumentsFileManager()
    var sourcesController: TWSourcesTableViewController? = nil

    override func setUp() {
        super.setUp()
        var files: Array<String> = ["File1", "File2", "File3"]
        fileSystemManager.directoryContents = files
        fileManager.fileSystemManager = fileSystemManager
        sourcesController = TWSourcesTableViewController(documentsFileManager: fileManager)
    }
    
    override func tearDown() {
        sourcesController = nil
        super.tearDown()
    }

    func testBeingATableViewDelegate() {
        let isDelegate = (sourcesController is UITableViewDelegate) == true
        XCTAssertTrue(isDelegate, "TWSourcesTableViewController should a table view delegate")
    }
    
    func testBeingATableViewDataSource() {
        let isDataSource = (sourcesController is UITableViewDataSource) == true
        XCTAssertTrue(isDataSource, "TWSourcesTableViewController should a table view data source")
    }

    func testReturningTheRightSectionsCount() {
        let sections = self.sourcesController!.numberOfSectionsInTableView(nil)
        XCTAssertEqual(sections, 1, "Should only support one section")
    }
    
    func testReturningTheRightRowsCount() {
        let rows: Int = self.sourcesController!.tableView(nil, numberOfRowsInSection:0)
        XCTAssertEqual(rows, 1, "There are three files and each row shows three items so one row is sufficient")
    }
    

    
    func testReturningRowsCountForOddNumberOfItems() {
        fileSystemManager.directoryContents = ["File1", "File2", "File3", "File4", "File5"]
        let rows = sourcesController!.tableView(nil, numberOfRowsInSection:0)
        XCTAssertEqual(rows, 2, "There are five files and each row shows three items so two rows are sufficient");
    }
    
//    func testReturningACellOfTheRightClass() {
//        let cell = self.sourcesController!.tableView(sourcesController!.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
//        let isSourcesCell = (cell is TWSourcesTableViewCell) == true
//        XCTAssertTrue(isSourcesCell, "All cells should be from the TWSourcesTableViewCell class");
//    }
    
//    func testReturningACellWithTheRightTitles() {
//        let cell = self.sourcesController!.tableView(sourcesController!.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
//        let sourceCell = cell as TWSourcesTableViewCell
//        XCTAssertEqual(sourceCell.title1, "File1", "The title of the first item in the cell should the first documents file");
//        XCTAssertEqual(sourceCell.title2, "File2", "The title of the second item in the cell should the second documents file");
//        XCTAssertEqual(sourceCell.title3, "File3", "The title of the third item in the cell should the third documents file");
//    }
    
//    func testHavingCellWithLessThanThreeItems() {
//        fileSystemManager.directoryContents = ["File1", "File2", "File3", "File4", "File5"];
//        let cell = sourcesController!.tableView(sourcesController!.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
//        let sourceCell = cell as TWSourcesTableViewCell
//        XCTAssertEqual(sourceCell.title1, "File4", "The title of the first item in the cell should the 4th documents file");
//        XCTAssertEqual(sourceCell.title2, "File5", "The title of the second item in the cell should the 5th documents file");
//        XCTAssertEqualObjects(sourceCell.title3, nil, "The title of the third item in the cell should be empty");
//    }
    
//    func testBeingADelegateToAllCells() {
//        let cell = sourcesController!.tableView(sourcesController!.tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
//        let sourceCell = cell as TWSourcesTableViewCell
//        let delegate = sourceCell.delegate
//        XCTAssertEqual(delegate as Void, sourcesController, "sourcesController should be the delegate for all of its cells");
//    }

}
