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
        let delay = Double(Double(arc4random_uniform(10)) / 10.0)
        //let movement = CGFloat(arc4random_uniform(5))
        let animationOptions:UIViewKeyframeAnimationOptions = [.allowUserInteraction, .repeat]
        let easeOptions:UIViewAnimationOptions = .repeat
        UIView.animate(withDuration: 0.5, delay: delay, options: easeOptions, animations: { () -> Void in
            UIView.animateKeyframes(withDuration: 0.60, delay: delay, options: animationOptions, animations: { () -> Void in
                var time = 0.0
                let duration = 0.15
                let radius:CGFloat = CGFloat(M_PI / 200.0);
                let originalFrame = self.frame
                UIView.addKeyframe(withRelativeStartTime: time, relativeDuration: duration, animations: { () -> Void in
                    let transform = CGAffineTransform(rotationAngle: -radius);
                    self.transform = transform;
                    var myFrame = self.frame
                    let movementX = -5.0 + CGFloat(arc4random_uniform(10))
                    let movementY = -5.0 + CGFloat(arc4random_uniform(10))
                    myFrame.origin.x += movementX
                    myFrame.origin.y += movementY
                    self.frame = myFrame
                })
                time += duration
                UIView.addKeyframe(withRelativeStartTime: time, relativeDuration: duration, animations: { () -> Void in
                    let transform = CGAffineTransform(rotationAngle: radius);
                    self.transform = transform;
                    var myFrame = self.frame
                    let movementX = -5.0 + CGFloat(arc4random_uniform(10))
                    let movementY = -5.0 + CGFloat(arc4random_uniform(10))
                    myFrame.origin.x += movementX
                    myFrame.origin.y += movementY
                    self.frame = myFrame
                })
                time += duration
                UIView.addKeyframe(withRelativeStartTime: time, relativeDuration: duration, animations: { () -> Void in
                    let transform = CGAffineTransform(rotationAngle: -radius);
                    self.transform = transform;
                    var myFrame = self.frame
                    let movementX = -5.0 + CGFloat(arc4random_uniform(10))
                    let movementY = -5.0 + CGFloat(arc4random_uniform(10))
                    myFrame.origin.x += movementX
                    myFrame.origin.y += movementY
                    self.frame = myFrame
                })
                time += duration
                UIView.addKeyframe(withRelativeStartTime: time, relativeDuration: duration, animations: { () -> Void in
                    let transform = CGAffineTransform(rotationAngle: 0);
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
