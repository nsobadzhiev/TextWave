//
//  TWSourcesTableViewCell.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/9/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit

class TWSourcesCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel? = nil
    @IBOutlet var thumbnailView: UIView! = nil
    
    var title: String? {
    get {
        return titleLabel?.text
    }
    set {
        if let title = newValue {
            self.titleLabel?.text = title
        }
    }
    }

    var imageView: UIView? {
        didSet {
            for subview in self.thumbnailView?.subviews as [UIView] {
                subview.removeFromSuperview()
            }
            self.imageView?.frame = self.thumbnailView.bounds
            self.imageView?.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight
            self.thumbnailView?.addSubview(self.imageView!)
        }
    }
}