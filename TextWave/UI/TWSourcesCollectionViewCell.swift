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
    
    func startShaking() {
        let delay = Double(Double(arc4random_uniform(10)) / 10.0)
        let movement = CGFloat(arc4random_uniform(5))
        let animationOptions = UIViewKeyframeAnimationOptions.AllowUserInteraction |
            UIViewKeyframeAnimationOptions.Repeat
        let easeOptions = UIViewAnimationOptions.CurveEaseInOut | UIViewAnimationOptions.Repeat
        UIView.animateWithDuration(0.6, delay: delay, options: easeOptions, animations: { () -> Void in
            UIView.animateKeyframesWithDuration(0.60, delay: delay, options: animationOptions, animations: { () -> Void in
                var time = 0.0
                let duration = 0.15
                let radius:CGFloat = CGFloat(M_PI / 64.0);
                let originalFrame = self.frame
                UIView.addKeyframeWithRelativeStartTime(time, relativeDuration: duration, animations: { () -> Void in
                    let transform = CGAffineTransformMakeRotation(-radius);
                    self.transform = transform;
                    var myFrame = self.frame
                    myFrame.origin.y -= movement
                    self.frame = myFrame
                })
                time += duration
                UIView.addKeyframeWithRelativeStartTime(time, relativeDuration: duration, animations: { () -> Void in
                    let transform = CGAffineTransformMakeRotation(radius);
                    self.transform = transform;
                    var myFrame = self.frame
                    myFrame.origin.y += movement
                    myFrame.origin.x += movement
                    self.frame = myFrame
                })
                time += duration
                UIView.addKeyframeWithRelativeStartTime(time, relativeDuration: duration, animations: { () -> Void in
                    let transform = CGAffineTransformMakeRotation(radius);
                    self.transform = transform;
                    var myFrame = self.frame
                    myFrame.origin.y -=  movement
                    myFrame.origin.x -= 2 * movement
                    self.frame = myFrame
                })
                time += duration
                UIView.addKeyframeWithRelativeStartTime(time, relativeDuration: duration, animations: { () -> Void in
                    let transform = CGAffineTransformMakeRotation(0);
                    self.transform = transform;
                    self.frame = originalFrame
                })
                time += duration
                }, completion: nil)
            }, 
            completion: nil)
    }
    
    func stopShaking() {
        self.layer.removeAllAnimations()
    }
}