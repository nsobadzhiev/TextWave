//
//  TWTabViewController.swift
//  TextWave
//
//  Created by Nikola Sobadjiev on 1/4/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import Foundation

class TWTabViewController : UIViewController {
    
    @IBOutlet var contentAreaView:UIView! = nil
    var automaticSegueIdentifiers:Array<String> = ["InitialEmbedSegue", "NowPlayingSegue"]
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueId = segue.identifier {
            if contains(automaticSegueIdentifiers, segueId) {
                return
            }
        }
        // don't execute this it initialEmbedSegue is being prepared. It is
        // going to be handled automatically by the storyboard
        let destinationController = segue.destinationViewController as UIViewController
        for childController in self.childViewControllers {
            childController.removeFromParentViewController()
        }
        self.addChildViewController(destinationController)
        destinationController.view.frame = self.contentAreaView.bounds
        self.contentAreaView.addSubview(destinationController.view)
        destinationController.didMoveToParentViewController(self)
    }
}