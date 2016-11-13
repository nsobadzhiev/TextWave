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
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionLayout.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(TWSourcesCollectionViewController.onNewFileAdded), name: NSNotification.Name(rawValue: AppDelegateFileAddedNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    
    func metadataForItem(indexPathIndexPath indexPath:NSIndexPath) -> TWFileMetadata? {
        let firstSourceFileName = fileManager.allDocumentPaths()[(indexPath as NSIndexPath).row] as? String
        let cachedMetadata = self.cachedMetadataForFile(firstSourceFileName)
        
        if cachedMetadata != nil {
            return cachedMetadata
        }
        else {
            if let firstSource = firstSourceFileName {
                let fileUrl = URL(string: firstSource)
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
    
    func cachedMetadataForFile(_ filePath:String?) -> TWFileMetadata? {
        if let filePath = filePath {
            let fileUrl = URL(string: filePath)
            for meta in self.fileMetadatas {
                if meta.fileUrl == fileUrl {
                    return meta
                }
            }
        }
        return nil
    }
    
    func filepathForIndex(_ indexPath:IndexPath) -> String? {
        return fileManager.allDocumentPaths()[(indexPath as NSIndexPath).row] as? String
    }
    
    func handleItemSelection(indexPath:IndexPath) {
        let filePath = self.filepathForIndex(indexPath)
        if let filePath = filePath {
            let fileUrl = URL(string: filePath)
            TWNowPlayingManager.instance.startPlaybackWithUrl(fileUrl, selectedItem: nil)
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nowPlayingController = mainStoryboard.instantiateViewController(withIdentifier: "NowPlayingViewController") as! TWNowPlayingViewController
            nowPlayingController.nowPlayingManager = TWNowPlayingManager.instance
            self.present(nowPlayingController, animated: true, completion: nil)
        }
    }
    
    func handleItemDeletion(indexPath:IndexPath) {
        let filePath = self.filepathForIndex(indexPath)
        if let filePath = filePath {
            let fileUrl = URL (string: filePath)
            do {
                try FileManager.default.removeItem(at: fileUrl!)
            }
            catch {
                // TODO: show error message
            }
            self.collectionView?.deleteItems(at: [indexPath])
        }
    }
    
    func onNewFileAdded() {
        self.collectionView?.reloadData()
    }
    
// MARK: - Button Actions
    
    @IBAction func unwindToSegue(_ segue: UIStoryboardSegue) {
        // Leave it empty.
    }
    
    @IBAction func enterEditingMode(_ sender: AnyObject!) {
        let editButton = sender as? UIBarButtonItem
        if self.isEditing {
            editButton?.title = NSLocalizedString("Edit", comment: "Sources collection view bar button")
        }
        else {
            editButton?.title = NSLocalizedString("Done", comment: "Sources collection view bar button")
        }
        self.isEditing = !self.isEditing
        
        let visibleCells = self.collectionView?.visibleCells
        for visibleCell in visibleCells! {
            let sourceCell = visibleCell as? TWSourcesCollectionViewCell
            if self.isEditing {
                sourceCell?.startShaking()
            }
            else {
                sourceCell?.stopShaking()
            }
        }
    }
// MARK: - Collection View Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileManager.allDocuments().count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseId = "SourcesCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! TWSourcesCollectionViewCell
        
        let fileMetadata = self.metadataForItem(indexPathIndexPath: indexPath as NSIndexPath)
        cell.title = fileMetadata?.titleForFile()
        cell.imageView = UIImageView(image: UIImage(named: self.defaultThumbnailImageName))
        fileMetadata?.thumbnailForFileWithBlock({(thumbnailView:UIView?) in
            if let thumbnailView = thumbnailView {
                cell.imageView = thumbnailView
            }
        })
        
        if self.isEditing == true {
            cell.startShaking()
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            // TODO: remove hardcoded values
            if ((indexPath as NSIndexPath).row % 2 == 0) {
                return CGSize(width: 150, height: 100)
            }
            else {
                return CGSize(width: 150, height: 200)
            }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isEditing {
            self.handleItemDeletion(indexPath: indexPath)
        }
        else {
            self.handleItemSelection(indexPath: indexPath)
        }
    }
    
    // MARK: layout data source
    
    func sourcesCollectionLayout(_ collectionLayout: TWSourcesCollectionLayout, imageSizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let metadata = self.metadataForItem(indexPathIndexPath: indexPath as NSIndexPath)
        let size = metadata?.thumbnailSize()
        if let size = size {
            return size
        }
        else {
            return CGSize.zero
        }
    }
    
    func sourcesCollectionLayout(_ collectionLayout: TWSourcesCollectionLayout, titleForItemAtIndexPath indexPath: IndexPath) -> NSString? {
        let metadata = self.metadataForItem(indexPathIndexPath: indexPath as NSIndexPath)
        return metadata?.titleForFile() as NSString?
    }

}
