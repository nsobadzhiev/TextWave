//
//  TWSourcesCollectionLayout.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 12/22/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation

protocol TWSourcesCollectionLayoutDataSource {
    func sourcesCollectionLayout(_ collectionLayout: TWSourcesCollectionLayout, imageSizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    func sourcesCollectionLayout(_ collectionLayout: TWSourcesCollectionLayout, titleForItemAtIndexPath indexPath: IndexPath) -> NSString?
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
    
    override func prepare() {
        assert((self.collectionView?.numberOfSections == 1), "Milti section collection views not supported")
        let itemsCount = self.collectionView?.numberOfItems(inSection: 0)
        var leftColumnHeight:Float = 0
        var rightColumnHeight:Float = 0
        self.totalHeight = 0
        self.layoutItems.removeAll(keepingCapacity: true)
        
        if itemsCount == 0 {
            return
        }
        
        if let itemsCount = itemsCount {
            for itemIndex in 0...(itemsCount - 1) {
                let indexPath = IndexPath(item: itemIndex, section: 0)
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
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                if (indexPath as NSIndexPath).row % 2 == 0 {
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
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutItems[(indexPath as NSIndexPath).row]
    }
    
    override var collectionViewContentSize : CGSize {
        if let collectionView = self.collectionView {
            return CGSize(width: Double(collectionView.frame.size.width), height: Double(self.totalHeight))
        }
        else {
            return CGSize.zero
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var itemsForRect: Array<UICollectionViewLayoutAttributes> = []
        for item in self.layoutItems {
            if rect.intersects(item.frame) {
                itemsForRect.append(item)   
            }
        }
        return itemsForRect
    }
    
    // MARK: private methods
    
    func heightForTitle(_ title: String?) -> Float {
        return 40;  // TODO: calculate dynamic title height
    }
}
