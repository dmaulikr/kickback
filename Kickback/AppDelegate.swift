//
//  AppDelegate.swift
//  Kickback
//
//  Created by Katie Jiang on 7/10/17.
//  Copyright © 2017 FBU. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var auth = SPTAuth()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        auth.redirectURL = URL(string: "Kickback://returnAfterLogin")
        auth.sessionUserDefaultsKey = "current session"
        
        // Initialize Parse
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "kickback"
                configuration.clientKey = "FacebookUniversityKickback"
                configuration.server = "https://kickback.herokuapp.com/parse"
            })
        )
        
        // Check for signed in user
        if let user = User.current {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UIViewController
            if let queueId = user.queueId {
                let query = PFQuery(className: "Queue")
                let parseQueue = try! query.getObjectWithId(queueId)
                if parseQueue["ownerId"] as! String == user.id {
                    vc = storyboard.instantiateViewController(withIdentifier: "createHomeViewController")
                } else {
                    vc = storyboard.instantiateViewController(withIdentifier: "joinHomeViewController")
                }
            } else {
                vc = storyboard.instantiateViewController(withIdentifier: "welcomeViewController")
            }
            let navigationController = UINavigationController(rootViewController: vc)
            window?.rootViewController = navigationController
        }
        
        return true
    }
    
    // 1 How to handle the callback URL
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // 2- check if app can handle redirect URL
        if auth.canHandle(auth.redirectURL) {
            // 3 - handle callback in closure
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) in
                // 4- handle error
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                // 5- Add session to User Defaults
                let userDefaults = UserDefaults.standard
                let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
                userDefaults.set(sessionData, forKey: "currentSPTSession")
                userDefaults.synchronize()
                // 6 - Set current user
                APIManager.current?.session = session
                APIManager.current?.createUser()
                // 7 - Tell notification center login is successful
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loginSuccessful"), object: nil)
            })
            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

