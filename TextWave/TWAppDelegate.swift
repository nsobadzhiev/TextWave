//
//  TWAppDelegate.swift
//  LazyReader
//
//  Created by Nikola Sobadjiev on 6/8/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

import UIKit
import AVFoundation

let AppDelegateFileAddedNotification = "AppDelegateFileAddedNotification"

@UIApplicationMain
class TWAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var fileManager: TWFileSystemManager = NSFileManager.defaultManager() as TWFileSystemManager
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let rootViewController = storyboard.instantiateInitialViewController() as? UIViewController
        let window:UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = rootViewController as UIViewController?
        window.makeKeyAndVisible()
        UIView.appearance().tintColor = UIColor(red: 240.0 / 255, green: 136.0 / 255, blue: 32 / 255, alpha: 1.0)
        self.setupAudioSession()
        
        return true
    }
    
    func setupAudioSession() {
        var audioSessionError:NSError? = nil
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, withOptions:AVAudioSessionCategoryOptions.allZeros, error: &audioSessionError)
        var activationError:NSError? = nil
        session.setActive(true, withOptions: nil, error:&activationError)
        if audioSessionError != nil || activationError != nil {
            println("Audio session category error: \(audioSessionError)")
            println("Audio session activation error: \(activationError)")
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        // TODO: Check whether the file can be handles by the app.
        let isValid = true
        if isValid {
            println("Opened URL from application \(sourceApplication) \(url.absoluteString)")
            // post a notification about a new document
            NSNotificationCenter.defaultCenter().postNotificationName(AppDelegateFileAddedNotification, object: nil)
            return true
        }
        // Supress the warning :)
//        else {
//            return false
//        }
    }
    
}
