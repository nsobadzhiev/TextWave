//
//  TWNowPlayingViewController.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/7/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import UIKit

class TWNowPlayingViewController : UIViewController, UIGestureRecognizerDelegate, DMTableOfContentsTableViewControllerDelegate, TWPlaybackManagerDelegate {
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
    
    var controlsFadeAnimationLength = 0.6
    var controlViewsXibAlpha:CGFloat = 0.0
    var previewController:TWPublicationPreviewViewControllerProtocol? = nil
    
    var playbackTitle: String = "" {
    didSet{
        if playbackTitleLabel != nil {
            playbackTitleLabel.text = self.playbackTitle
        }
    }
    }
    
    var playbackManager: TWPlaybackManager? = nil {
        didSet{
            self.playbackManager?.delegate = self
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
        self.setupControls()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("hideControls"), userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupPreview() {
        let previewController = TWPublicationPreviewViewControllerFactory.previewViewControllerForUrl(self.playbackManager?.playbackSource?.sourceURL, selectedItem: self.nowPlayingManager?.selectedItem)
        if let previewController = previewController {
            self.addChildViewController(previewController)
            previewController.view.frame = CGRectMake(0.0, 0.0, self.previewView.frame.size.width, self.previewView.frame.size.height)
            self.previewView.addSubview(previewController.view)
            previewController.didMoveToParentViewController(self)
            controlViewsXibAlpha = self.controlsView.alpha
            self.previewController = previewController
        }
    }
    
    func setupControls() {
        self.contentsButton.hidden = (TWPublicationPreviewViewControllerFactory.supportsTableOfContents(self.playbackManager?.playbackSource?.sourceURL) == false)
    }
    
    // MARK: Controls view actions
    
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
        self.toggleControls()
    }
    
    func toggleControls() {
        UIView.animateWithDuration(self.controlsFadeAnimationLength, animations: {() in 
            self.controlsView.alpha = self.controlViewsXibAlpha - self.controlsView.alpha
            self.titleView.alpha = self.controlViewsXibAlpha - self.titleView.alpha
            self.pagesView.alpha = self.controlViewsXibAlpha - self.pagesView.alpha
        })
    }
    
    func hideControls() {
        UIView.animateWithDuration(self.controlsFadeAnimationLength, animations: {() in 
            self.controlsView.alpha = 0
            self.titleView.alpha = 0
            self.pagesView.alpha = 0
        })
    }
    
    func dismissTableOfContents() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Title view actions
    
    @IBAction func onBackTap(sender: AnyObject) {
        if self.navigationController != nil {
            self.navigationController?.popViewControllerAnimated(true)
        }
        else if self.presentingViewController != nil {
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func onContentsTap(sender: AnyObject) {
        let contentsController = TWPublicationPreviewViewControllerFactory.tableOfContentsControllerForUrl(self.playbackManager?.playbackSource?.sourceURL)
        if let contentsController = contentsController {
            contentsController.delegate = self
            contentsController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "dismissTableOfContents")
            let contentNavigationController = UINavigationController(rootViewController: contentsController)
            self.presentViewController(contentNavigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func onBookmarksTap(sender: AnyObject) {
        // TODO: show bookmarks
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: DMTableOfContentsTableViewControllerDelegate
    
    func tableOfContentsController(tocController: DMTableOfContentsTableViewController!, didSelectItemWithPath path: String!) {
        self.previewController?.goToSection(sectionName: path)
        self.dismissTableOfContents()
    }
    
    // MARK: TWPlaybackManager
    
    func playbackManager(playback: TWPlaybackManager, didBeginItemAtIndex index: Int) {
        self.playbackProgressSlider.progress = 0.0
    }
    
    func playbackManager(playback: TWPlaybackManager, didFinishItemAtIndex index: Int) {
        self.playbackProgressSlider.progress = 1.0
    }
    
    func playbackManager(playback: TWPlaybackManager, didMoveToPosition index: Int) {
        let wholeText = self.playbackManager?.currentText
        if let wholeText = wholeText {
            let wholeTextLength:Float = Float(wholeText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            let progress = Float(playback.letterIndex) / wholeTextLength
            self.playbackProgressSlider.setProgress(progress, animated: true)
        }
    }
}