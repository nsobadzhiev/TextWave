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
    @IBOutlet var imageView: UIImageView? = nil
    
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

    var image: UIImage? {
    get {
        return imageView?.image
    }
    set {
        if let image = newValue {
            self.imageView?.image = image
        }
    }
    }
}