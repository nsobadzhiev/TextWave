//
//  TWNowPlayingViewController.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/7/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import UIKit

class TWNowPlayingViewController : UIViewController {
    @IBOutlet var playbackTitleLabel: UILabel! = nil
    @IBOutlet var previousButton: UIButton! = nil
    @IBOutlet var skipBackwardsButton: UIButton! = nil
    @IBOutlet var playButton: UIButton! = nil
    @IBOutlet var skipForwardButton: UIButton! = nil
    @IBOutlet var nextButton: UIButton! = nil
    @IBOutlet var playbackProgressSlider: UISlider! = nil
    @IBOutlet var moreButton: UIBarButtonItem! = nil
    @IBOutlet var previewView: UIView! = nil
    
    var playbackTitle: String = "" {
    didSet{
        if playbackTitleLabel != nil {
            playbackTitleLabel.text = self.playbackTitle
        }
    }
    }
    
    var playbackManager: TWPlaybackManager? = nil {
        didSet{
            if let title = self.playbackManager?.playbackSource?.title {
                self.playbackTitle = title
            }
        }
    }
    var nowPlayingManager: TWNowPlayingManager? = TWNowPlayingManager.instance {
    didSet{
        self.playbackManager = self.nowPlayingManager?.playbackManager;
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playbackManager = self.nowPlayingManager?.playbackManager
        playbackTitleLabel.text = self.playbackTitle
        self.setupPreview()
    }
    
    func setupPreview() {
        let previewController = TWPublicationPreviewViewControllerFactory.previewViewControllerForUrl(self.playbackManager?.playbackSource?.sourceURL, selectedItem: self.nowPlayingManager?.selectedItem)
        if let previewController = previewController {
            self.addChildViewController(previewController)
            previewController.view.frame = CGRectMake(0.0, 0.0, self.previewView.frame.size.width, self.previewView.frame.size.height)
            self.previewView.addSubview(previewController.view)
            previewController.didMoveToParentViewController(self)
            self.previewView.layer.borderColor = UIColor.blackColor().CGColor
            self.previewView.layer.borderWidth = 3.0
        }
    }
    
    @IBAction func onPreviousTap(sender: AnyObject) {
        self.playbackManager?.previous()
    }
    
    @IBAction func onSkipBackwardsTap(sender: AnyObject) {
        self.playbackManager?.skipBackwards()
    }
    
    @IBAction func onPlayTap(sender: AnyObject) {
        if self.playbackManager?.isPlaying == true {
            self.playbackManager?.pause()
        }
        else {
            self.playbackManager?.resume()
        }
    }
    
    @IBAction func onSkipForwardTap(sender: AnyObject) {
        self.playbackManager?.skipForward()
    }
    
    @IBAction func onNextTap(sender: AnyObject) {
        self.playbackManager?.next()
    }
    
    @IBAction func onProgressSliderChangedValue(sender: AnyObject) {
        let slider = sender as UISlider
        let sliderValue = slider.value
        self.playbackManager?.setPlaybackProgress(sliderValue)
    }
}