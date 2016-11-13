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
    var fileManager: TWFileSystemManager = FileManager.default as TWFileSystemManager
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let docsDir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
            print("Documents dir: \(docsDir)")
        #endif
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rootViewController = storyboard.instantiateInitialViewController()
        let window:UIWindow = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = rootViewController as UIViewController?
        window.makeKeyAndVisible()
        UIView.appearance().tintColor = UIColor(red: 150.0 / 255, green: 150.0 / 255, blue: 150.0 / 255, alpha: 1.0)
        self.setupAudioSession()
        
        return true
    }
    
    func setupAudioSession() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback, with:AVAudioSessionCategoryOptions())
            try session.setActive(true, with: .notifyOthersOnDeactivation)
        }
        catch {
            // TODO: get reason from exception
            print("Audio session category error")
            print("Audio session activation error")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // TODO: Check whether the file can be handles by the app.
        let isValid = true
        if isValid {
            print("Opened URL from application \(sourceApplication) \(url.absoluteString)")
            // post a notification about a new document
            NotificationCenter.default.post(name: Notification.Name(rawValue: AppDelegateFileAddedNotification), object: nil)
            return true
        }
        // Supress the warning :)
//        else {
//            return false
//        }
    }
    
}
