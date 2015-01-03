//
//  TWNowPlayingViewController.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/7/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import UIKit

class TWNowPlayingViewController : UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var playbackTitleLabel: UILabel! = nil
    @IBOutlet var playbackSubtitleLabel: UILabel! = nil
    @IBOutlet var previousButton: UIButton! = nil
    @IBOutlet var skipBackwardsButton: UIButton! = nil
    @IBOutlet var playButton: UIButton! = nil
    @IBOutlet var skipForwardButton: UIButton! = nil
    @IBOutlet var nextButton: UIButton! = nil
    @IBOutlet var playbackProgressSlider: UIProgressView! = nil
    @IBOutlet var contentsButton: UIButton! = nil
    @IBOutlet var bookmarksButton: UIButton! = nil
    @IBOutlet var backButton: UIButton! = nil
    @IBOutlet var previewView: UIView! = nil
    @IBOutlet var controlsView: UIView! = nil
    @IBOutlet var titleView: UIView! = nil
    @IBOutlet var pagesView: UIView! = nil
    @IBOutlet var tapRecognizer: UITapGestureRecognizer! = nil
    
    var controlsFadeAnimationLength = 0.6
    var controlViewsXibAlpha:CGFloat = 0.0
    
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
            self.navigationController?.navigationBarHidden = true
            controlViewsXibAlpha = self.controlsView.alpha
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
    
    @IBAction func onBackgroundTap(sender: AnyObject) {
        UIView.animateWithDuration(self.controlsFadeAnimationLength, animations: {() in 
            self.controlsView.alpha = self.controlViewsXibAlpha - self.controlsView.alpha
            self.titleView.alpha = self.controlViewsXibAlpha - self.titleView.alpha
            self.pagesView.alpha = self.controlViewsXibAlpha - self.pagesView.alpha
        })
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}