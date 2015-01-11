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
    var selectedTabButton:UIButton? = nil
    var automaticSegueIdentifiers:Array<String> = ["InitialEmbedSegue", "NowPlayingSegue"]
    
    @IBOutlet var libraryButton:UIButton! = nil
    @IBOutlet var searchButton:UIButton! = nil
    @IBOutlet var nowPlayingButton:UIButton! = nil
    @IBOutlet var settingsButton:UIButton! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedTabButton = libraryButton
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // don't execute this it initialEmbedSegue is being prepared. It is
        // going to be handled automatically by the storyboard
        if let segueId = segue.identifier {
            if contains(automaticSegueIdentifiers, segueId) {
                return
            }
        }
        if sender as? UIButton == self.selectedTabButton {
            // assume the controller doesn't have to be changed
            return
        }
        
        let destinationController = segue.destinationViewController as UIViewController
        for childController in self.childViewControllers {
            childController.removeFromParentViewController()
        }
        self.addChildViewController(destinationController)
        destinationController.view.frame = self.contentAreaView.bounds
        self.contentAreaView.addSubview(destinationController.view)
        destinationController.didMoveToParentViewController(self)
        self.selectedTabButton = sender as? UIButton
    }
}