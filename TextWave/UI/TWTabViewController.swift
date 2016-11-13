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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nowPlayingButton.isEnabled = TWNowPlayingManager.instance.hasPlaybackItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // don't execute this it initialEmbedSegue is being prepared. It is
        // going to be handled automatically by the storyboard
        if let segueId = segue.identifier {
            if automaticSegueIdentifiers.contains(segueId) {
                return
            }
        }
        if sender as? UIButton == self.selectedTabButton {
            // assume the controller doesn't have to be changed
            return
        }
        
        let destinationController = segue.destination as UIViewController
        for childController in self.childViewControllers {
            childController.removeFromParentViewController()
        }
        self.addChildViewController(destinationController)
        destinationController.view.frame = self.contentAreaView.bounds
        self.contentAreaView.addSubview(destinationController.view)
        destinationController.didMove(toParentViewController: self)
        self.selectedTabButton = sender as? UIButton
    }
    
    // MARK: Remote control events
    
    override func remoteControlReceived(with event: UIEvent?) {
        if let event = event {
            TWNowPlayingManager.instance.handleRemoteControlEvent(event)
        }
    }
}
