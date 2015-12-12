//
//  TWSourcesTableViewController.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/9/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWSourcesCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout, TWSourcesCollectionLayoutDataSource {
    
    @IBOutlet var collectionLayout: TWSourcesCollectionLayout!
    var fileManager = TWDocumentsFileManager()
    var fileMetadatas:Array<TWFileMetadata> = []
    let defaultThumbnailImageName = "defaultCover"
    
    init(documentsFileManager: TWDocumentsFileManager) {
        super.init(nibName: nil, bundle: nil)
        fileManager = documentsFileManager
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionLayout.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onNewFileAdded"), name: AppDelegateFileAddedNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    
    func metadataForItem(indexPath indexPath:NSIndexPath) -> TWFileMetadata? {
        let firstSourceFileName = fileManager.allDocumentPaths()[indexPath.row] as? String
        let cachedMetadata = self.cachedMetadataForFile(firstSourceFileName)
        
        if cachedMetadata != nil {
            return cachedMetadata
        }
        else {
            if let firstSource = firstSourceFileName {
                let fileUrl = NSURL(string: firstSource)
                let metadata = TWFileMetadataFactory.metadataForFile(fileUrl)
                if let metadata = metadata {
                    self.fileMetadatas.append(metadata)
                }
                return metadata
            }
            else {
                return nil
            }
        }
    }
    
    func cachedMetadataForFile(filePath:String?) -> TWFileMetadata? {
        if let filePath = filePath {
            let fileUrl = NSURL(string: filePath)
            for meta in self.fileMetadatas {
                if meta.fileUrl == fileUrl {
                    return meta
                }
            }
        }
        return nil
    }
    
    func filepathForIndex(indexPath:NSIndexPath) -> String? {
        return fileManager.allDocumentPaths()[indexPath.row] as? String
    }
    
    func handleItemSelection(indexPath indexPath:NSIndexPath) {
        let filePath = self.filepathForIndex(indexPath)
        if let filePath = filePath {
            let fileUrl = NSURL(string: filePath)
            TWNowPlayingManager.instance.startPlaybackWithUrl(fileUrl, selectedItem: nil)
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nowPlayingController = mainStoryboard.instantiateViewControllerWithIdentifier("NowPlayingViewController") as! TWNowPlayingViewController
            nowPlayingController.nowPlayingManager = TWNowPlayingManager.instance
            self.presentViewController(nowPlayingController, animated: true, completion: nil)
        }
    }
    
    func handleItemDeletion(indexPath indexPath:NSIndexPath) {
        let filePath = self.filepathForIndex(indexPath)
        if let filePath = filePath {
            let fileUrl = NSURL (string: filePath)
            do {
                try NSFileManager.defaultManager().removeItemAtURL(fileUrl!)
            }
            catch {
                // TODO: show error message
            }
            self.collectionView?.deleteItemsAtIndexPaths([indexPath])
        }
    }
    
    func onNewFileAdded() {
        self.collectionView?.reloadData()
    }
    
// MARK: - Button Actions
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        // Leave it empty.
    }
    
    @IBAction func enterEditingMode(sender: AnyObject!) {
        let editButton = sender as? UIBarButtonItem
        if self.editing {
            editButton?.title = NSLocalizedString("Edit", comment: "Sources collection view bar button")
        }
        else {
            editButton?.title = NSLocalizedString("Done", comment: "Sources collection view bar button")
        }
        self.editing = !self.editing
        
        let visibleCells = self.collectionView?.visibleCells()
        for visibleCell in visibleCells! {
            let sourceCell = visibleCell as? TWSourcesCollectionViewCell
            if self.editing {
                sourceCell?.startShaking()
            }
            else {
                sourceCell?.stopShaking()
            }
        }
    }
// MARK: - Collection View Methods
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileManager.allDocuments().count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseId = "SourcesCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as! TWSourcesCollectionViewCell
        
        let fileMetadata = self.metadataForItem(indexPath: indexPath)
        cell.title = fileMetadata?.titleForFile()
        cell.imageView = UIImageView(image: UIImage(named: self.defaultThumbnailImageName))
        fileMetadata?.thumbnailForFileWithBlock({(thumbnailView:UIView?) in
            if let thumbnailView = thumbnailView {
                cell.imageView = thumbnailView
            }
        })
        
        if self.editing == true {
            cell.startShaking()
        }
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            // TODO: remove hardcoded values
            if (indexPath.row % 2 == 0) {
                return CGSizeMake(150, 100)
            }
            else {
                return CGSizeMake(150, 200)
            }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.editing {
            self.handleItemDeletion(indexPath: indexPath)
        }
        else {
            self.handleItemSelection(indexPath: indexPath)
        }
    }
    
    // MARK: layout data source
    
    func sourcesCollectionLayout(collectionLayout: TWSourcesCollectionLayout, imageSizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let metadata = self.metadataForItem(indexPath: indexPath)
        let size = metadata?.thumbnailSize()
        if let size = size {
            return size
        }
        else {
            return CGSizeZero
        }
    }
    
    func sourcesCollectionLayout(collectionLayout: TWSourcesCollectionLayout, titleForItemAtIndexPath indexPath: NSIndexPath) -> NSString? {
        let metadata = self.metadataForItem(indexPath: indexPath)
        return metadata?.titleForFile()
    }

}