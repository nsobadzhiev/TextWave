//
//  TWNowPlayingViewController.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 7/7/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


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
    
    var playbackSubtitle: String? = "" {
        didSet{
            if playbackSubtitleLabel != nil {
                playbackSubtitleLabel.text = self.playbackSubtitle
            }
        }
    }
    
    var playbackManager: TWPlaybackManager? = nil {
        didSet{
            self.playbackManager?.delegate = self
            if let title = self.playbackManager?.playbackSource?.title {
                self.playbackTitle = title
            }
            self.playbackSubtitle = self.playbackManager?.playbackSource?.subtitle
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
        // TODO: rethink getting metadata
        let metaInfo = TWFileMetadataFactory.metadataForFile(self.playbackManager?.playbackSource?.sourceURL)
        playbackTitleLabel.text = metaInfo?.titleForFile()
        playbackSubtitleLabel.text = self.playbackSubtitle
        controlViewsXibAlpha = self.controlsView.alpha
        self.setupPreview()
        self.setupControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(hideControls), userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupPreview() {
        let previewController = TWPublicationPreviewViewControllerFactory.previewViewControllerForUrl(self.playbackManager?.playbackSource?.sourceURL, selectedItem: self.nowPlayingManager?.selectedItem)
        if let previewController = previewController {
            self.addChildViewController(previewController)
            previewController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.previewView.frame.size.width, height: self.previewView.frame.size.height)
            self.previewView.addSubview(previewController.view)
            previewController.didMove(toParentViewController: self)
            self.previewController = previewController
        }
    }
    
    func setupControls() {
        let isSinglePage = (self.playbackManager?.playbackSource?.numberOfItems <= 1)
        self.contentsButton.isHidden = isSinglePage
        self.previousButton.isHidden = isSinglePage
        self.nextButton.isHidden = isSinglePage
        self.bookmarksButton.isHidden = isSinglePage
        if (isSinglePage) {
            self.pagesView.removeFromSuperview()
        }
    }
    
    // MARK: Controls view actions
    
    @IBAction func onPreviousTap(_ sender: AnyObject) {
        self.playbackManager?.previous()
    }
    
    @IBAction func onSkipBackwardsTap(_ sender: AnyObject) {
        self.playbackManager?.skipBackwards()
    }
    
    @IBAction func onPlayTap(_ sender: AnyObject) {
        if self.playbackManager?.isPlaying == true {
            self.playbackManager?.pause()
            self.playButton.setImage(UIImage.init(named: "play"), for: UIControlState())
        }
        else {
            self.playbackManager?.resume()
            self.playButton.setImage(UIImage.init(named: "pause"), for: UIControlState())
        }
    }
    
    @IBAction func onSkipForwardTap(_ sender: AnyObject) {
        self.playbackManager?.skipForward()
    }
    
    @IBAction func onNextTap(_ sender: AnyObject) {
        self.playbackManager?.next()
    }
    
    @IBAction func onProgressSliderChangedValue(_ sender: AnyObject) {
        let slider = sender as! UISlider
        let sliderValue = slider.value
        self.playbackManager?.setPlaybackProgress(sliderValue)
    }
    
    @IBAction func onBackgroundTap(_ sender: AnyObject) {
        self.toggleControls()
    }
    
    func toggleControls() {
        weak var weakSelf = self
        UIView.animate(withDuration: self.controlsFadeAnimationLength, animations: {() in 
            weakSelf?.controlsView.alpha = self.controlViewsXibAlpha - self.controlsView.alpha
            weakSelf?.titleView.alpha = self.controlViewsXibAlpha - self.titleView.alpha
            weakSelf?.pagesView.alpha = self.controlViewsXibAlpha - self.pagesView.alpha
        })
    }
    
    func hideControls() {
        weak var weakSelf = self
        UIView.animate(withDuration: self.controlsFadeAnimationLength, animations: {() in 
            weakSelf?.controlsView.alpha = 0
            weakSelf?.titleView.alpha = 0
            weakSelf?.pagesView.alpha = 0
        })
    }
    
    func dismissTableOfContents() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Title view actions
    
    @IBAction func onBackTap(_ sender: AnyObject) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else if self.presentingViewController != nil {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onContentsTap(_ sender: AnyObject) {
        let contentsController = TWPublicationPreviewViewControllerFactory.tableOfContentsControllerForUrl(self.playbackManager?.playbackSource?.sourceURL)
        if let contentsController = contentsController {
            contentsController.delegate = self
            contentsController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(dismissTableOfContents))
            let contentNavigationController = UINavigationController(rootViewController: contentsController)
            self.present(contentNavigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func onBookmarksTap(_ sender: AnyObject) {
        // TODO: show bookmarks
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: DMTableOfContentsTableViewControllerDelegate
    
    func table(ofContentsController tocController: DMTableOfContentsTableViewController!, didSelectItemWithPath path: String!) {
        self.previewController?.goToSection(sectionName: path)
        self.dismissTableOfContents()
    }
    
    // MARK: TWPlaybackManager
    
    func playbackManager(_ playback: TWPlaybackManager, didBeginItemAtIndex index: Int) {
        self.playbackProgressSlider.progress = 0.0
        
        // open the next item in the preview window
        self.previewController?.goToSection(index)
    }
    
    func playbackManager(_ playback: TWPlaybackManager, didFinishItemAtIndex index: Int) {
        self.playbackProgressSlider.progress = 1.0
    }
    
    func playbackManager(_ playback: TWPlaybackManager, didMoveToPosition index: Int) {
        let wholeText = self.playbackManager?.currentText
        if let wholeText = wholeText {
            let wholeTextLength:Float = Float(wholeText.lengthOfBytes(using: String.Encoding.utf8))
            let progress = Float(playback.letterIndex) / wholeTextLength
            self.playbackProgressSlider.setProgress(progress, animated: true)
        }
    }
    
    // MARK: Remote control events
    
    override func remoteControlReceived(with event: UIEvent?) {
        if let event = event {
            if event.type == UIEventType.remoteControl {
                switch event.subtype {
                case .remoteControlPlay:
                    self.onPlayTap(self)
                    break
                case .remoteControlPause:
                    self.onPlayTap(self)
                    break
                case .remoteControlNextTrack:
                    self.onNextTap(self)
                    break
                case .remoteControlPreviousTrack:
                    self.onPreviousTap(self)
                    break
                case .remoteControlTogglePlayPause:
                    self.onPlayTap(self)
                    break
                case .remoteControlEndSeekingBackward:
                    // TODO: figure out the new position
                    break;
                case .remoteControlEndSeekingForward:
                    // TODO: figure out the new position
                    break;
                default:
                    // do nothing
                    break
                }
            }
        }
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookmarksTable" {
            let bookmarksNavigationController = segue.destination as? UINavigationController
            let bookmarksViewController = bookmarksNavigationController?.topViewController as? TWBookmarksViewController
            let encodedFileName = self.playbackManager?.playbackSource?.sourceURL?.lastPathComponent as NSString?
            let fileName = encodedFileName?.removingPercentEncoding
            bookmarksViewController?.filePath = fileName
        }
    }
    
    override func performSegue(withIdentifier identifier: String?, sender: Any?) {
        
    }
    
    override func canPerformUnwindSegueAction(_ action: Selector,
        from fromViewController: UIViewController,
        withSender sender: Any) -> Bool {
            return true;
    }
    
    func unwindToSegue(_ segue: UIStoryboardSegue) {
        
    }
}
