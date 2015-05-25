//
//  TWBookmarksViewController.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 4/30/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWBookmarksViewController : UITableViewController {
    var filePath:String? = nil
    let bookmarksManager = DMBookmarkManager()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarksManager.bookmarksForPath(self.filePath).count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("BookmarkCell") as? TWBookmarkCell
        if cell == nil {
            cell = TWBookmarkCell()
        }
        let bookmark = self.bookmarksManager.bookmarksForPath(self.filePath)[indexPath.row] as? DMBookmark
        cell?.title = bookmark?.fileSection
        //cell?.loadThumbnailWithString(bookmark?.fileSection, baseUrl:bookmark?.fileName)
        return cell!
    }
}