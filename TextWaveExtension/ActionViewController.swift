//
//  ActionViewController.swift
//  TextWaveExtension
//
//  Created by Nikola Sobadjiev on 8/2/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var addToLibraryButton: UIButton!
    weak var nowPlayingController: TWNowPlayingViewController!
    
    var htmlText: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        for item: AnyObject in self.extensionContext!.inputItems {
            let inputItem = item as! NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeHTML as String) {
                    itemProvider.loadItemForTypeIdentifier(kUTTypeHTML as String, options: nil, completionHandler: { (html, error) in
                        if html != nil {
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                // handle html text
                                let htmlString:String? = html as? String
                                var tempDir = NSTemporaryDirectory();
                                let tempFileName = "actionWebPage.html"
                                tempDir = tempDir.stringByAppendingString("/\(tempFileName)")
                                let tempFileUrl = NSURL(fileURLWithPath: tempDir)
                                do {
                                    try htmlString?.writeToFile(tempDir, atomically: false, encoding: NSUTF8StringEncoding)
                                }
                                catch {
                                    print("Unable to write file: \(tempDir)")
                                }
                                TWNowPlayingManager.instance.startPlaybackWithUrl(tempFileUrl)
                                self.nowPlayingController.nowPlayingManager = TWNowPlayingManager.instance
                                // enable add to library button
                                self.addToLibraryButton.enabled = true;
                            }
                        }
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    @IBAction func onAddToLibrary(sender:AnyObject!) {
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedNowPlayingControllerSegue" {
            let destination = segue.destinationViewController
            self.nowPlayingController = destination as? TWNowPlayingViewController
        }
    }
}
