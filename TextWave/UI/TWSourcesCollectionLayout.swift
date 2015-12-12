//
//  TWSourcesCollectionLayout.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/22/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWSourcesCollectionLayoutDataSource {
    func sourcesCollectionLayout(collectionLayout: TWSourcesCollectionLayout, imageSizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    func sourcesCollectionLayout(collectionLayout: TWSourcesCollectionLayout, titleForItemAtIndexPath indexPath: NSIndexPath) -> NSString?
}

class TWSourcesCollectionLayout : UICollectionViewLayout {
    
    var layoutItems: Array<UICollectionViewLayoutAttributes> = []
    var totalHeight: Float = 0
    var delegate: TWSourcesCollectionLayoutDataSource? = nil
    
    var itemWidth: Float = 150.0 {
        didSet {
            self.invalidateLayout()
        }
    }
    
    override func prepareLayout() {
        assert((self.collectionView?.numberOfSections() == 1), "Milti section collection views not supported")
        let itemsCount = self.collectionView?.numberOfItemsInSection(0)
        var leftColumnHeight:Float = 0
        var rightColumnHeight:Float = 0
        self.totalHeight = 0
        self.layoutItems.removeAll(keepCapacity: true)
        
        if itemsCount == 0 {
            return
        }
        
        if let itemsCount = itemsCount {
            for itemIndex in 0...(itemsCount - 1) {
                let indexPath = NSIndexPath(forItem: itemIndex, inSection: 0)
                let itemImageSize = self.delegate?.sourcesCollectionLayout(self, imageSizeForItemAtIndexPath: indexPath)
                let itemTitle = self.delegate?.sourcesCollectionLayout(self, titleForItemAtIndexPath: indexPath)
                let titleHeight = self.heightForTitle(itemTitle as? String)
                var imageRatio = 0.5
                if let originalImageHeight = itemImageSize?.height {
                    if let originalImageWidth = itemImageSize?.width {
                        if originalImageWidth != 0 {
                            imageRatio = Double(originalImageHeight / originalImageWidth)
                        }
                    }
                }
                let imageHeight = Double(self.itemWidth) * imageRatio
                var itemHeight = titleHeight
                itemHeight += Float(imageHeight)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                if indexPath.row % 2 == 0 {
                    itemAttributes.frame = CGRect(x: 5.0, y: Double(leftColumnHeight), width: Double(self.itemWidth), height: Double(itemHeight))
                    leftColumnHeight += itemHeight
                }
                else {
                    itemAttributes.frame = CGRect(x: Double(10.0 + self.itemWidth), y: Double(rightColumnHeight), width: Double(self.itemWidth), height: Double(itemHeight))
                    rightColumnHeight += itemHeight
                }
                
                self.layoutItems.append(itemAttributes)
            }
            self.totalHeight = max(leftColumnHeight, rightColumnHeight)
        }
    }
    
    // MARK: collection layout
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutItems[indexPath.row]
    }
    
    override func collectionViewContentSize() -> CGSize {
        if let collectionView = self.collectionView {
            return CGSize(width: Double(collectionView.frame.size.width), height: Double(self.totalHeight))
        }
        else {
            return CGSizeZero
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var itemsForRect: Array<UICollectionViewLayoutAttributes> = []
        for item in self.layoutItems {
            if rect.intersects(item.frame) {
                itemsForRect.append(item)   
            }
        }
        return itemsForRect
    }
    
    // MARK: private methods
    
    func heightForTitle(title: String?) -> Float {
        return 40;  // TODO: calculate dynamic title height
    }
}