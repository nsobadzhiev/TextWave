//
//  TWBookmarksViewController.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 4/30/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import UIKit

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
        // this will provide a metadata object that can be used to obtain a human readable version
        // of the title (not file name, a proper title)
        let fullFilePath = TWDocumentsFileManager().fullPathForFileWithName(bookmark?.fileName)
        let epubManager = DMePubManager(epubPath: fullFilePath)
        let fullSectionUrl = epubManager.fullUrlForResource(bookmark?.fileSection)
        let fileMetadata = TWFileMetadataFactory.metadataForFile(fullSectionUrl)
        cell?.title = fileMetadata?.titleForFile()
        // TODO: add thumbnail
//        cell?.imageView = UIImageView(image: UIImage(named: self.defaultThumbnailImageName))
//        fileMetadata?.thumbnailForFileWithBlock({(thumbnailView:UIView?) in
//            if let thumbnailView = thumbnailView {
//                cell.imageView = thumbnailView
//            }
//        })
        return cell!
    }
}