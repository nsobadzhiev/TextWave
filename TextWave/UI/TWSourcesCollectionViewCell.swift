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
            for subview in (self.thumbnailView?.subviews)! {
                subview.removeFromSuperview()
            }
            self.imageView?.frame = self.thumbnailView.bounds
            self.imageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.thumbnailView?.addSubview(self.imageView!)
        }
    }
    
    func startShaking() {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.values = [NSValue(caTransform3D:CATransform3DMakeTranslation(-2.0, 0.0, 0.0)),
        NSValue(caTransform3D:CATransform3DMakeTranslation(2.0, 0.0, 0.0)),
        NSValue(caTransform3D:CATransform3DMakeRotation((CGFloat) (-1.0/180.0 * M_PI), 0, 0, 1)),
        NSValue(caTransform3D:CATransform3DMakeRotation((CGFloat) (1.0/180.0 * M_PI), 0, 0, 1))]
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.duration = 0.3
        self.layer.add(animation, forKey: nil)
    }
    
    func stopShaking() {
        self.layer.removeAllAnimations()
    }
}
