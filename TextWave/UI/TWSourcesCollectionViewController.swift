//
//  TWSourcesTableViewController.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/9/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWSourcesCollectionViewController : UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TWSourcesCollectionLayoutDataSource {
    
    @IBOutlet var collectionLayout: TWSourcesCollectionLayout!
    let fileManager = TWDocumentsFileManager()
    let defaultThumbnailImageName = "defaultCover"
    
    init(documentsFileManager: TWDocumentsFileManager) {
        super.init(nibName: nil, bundle: nil)
        fileManager = documentsFileManager;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionLayout.delegate = self
    }
    
// MARK: - Button Actions
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        // Leave it empty.
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as TWSourcesCollectionViewCell
        
        var firstSourceFileName = fileManager.allDocumentPaths()[indexPath.row] as? String
        
        if let firstSource = firstSourceFileName {
            let fileUrl = NSURL(string: firstSource)
            let fileMetadata = TWFileMetadataFactory.metadataForFile(fileUrl)
            cell.title = fileMetadata?.titleForFile()
            cell.imageView = UIImageView(image: UIImage(named: self.defaultThumbnailImageName))
            fileMetadata?.thumbnailForFileWithBlock({(thumbnailView:UIView?) in
                cell.imageView = thumbnailView
            })
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
        var filePath = fileManager.allDocumentPaths()[indexPath.row] as? String
        filePath = filePath?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        if let filePath = filePath {
            let fileUrl = NSURL(string: filePath)
            TWNowPlayingManager.instance.startPlaybackWithUrl(fileUrl, selectedItem: nil)
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nowPlayingController = mainStoryboard.instantiateViewControllerWithIdentifier("NowPlayingViewController") as TWNowPlayingViewController
            nowPlayingController.nowPlayingManager = TWNowPlayingManager.instance
            self.navigationController?.pushViewController(nowPlayingController, animated: true)
        }
    }
    
    // MARK: layout data source
    
    func sourcesCollectionLayout(collectionLayout: TWSourcesCollectionLayout, imageForItemAtIndexPath indexPath: NSIndexPath) -> UIImage? {
        let fileName = fileManager.allDocumentPaths()[indexPath.row] as? String
        let epubManager = DMePubManager(epubPath: fileName)
        let cover = epubManager.coverWithError(nil)
        if cover != nil {
            return cover
        }
        else {
            return UIImage(named: "defaultCover");
        }
    }
    
    func sourcesCollectionLayout(collectionLayout: TWSourcesCollectionLayout, titleForItemAtIndexPath indexPath: NSIndexPath) -> NSString? {
        let fileName = fileManager.allDocumentPaths()[indexPath.row] as? String
        let epubManager = DMePubManager(epubPath: fileName)
        return epubManager.titleWithError(nil)
    }

}