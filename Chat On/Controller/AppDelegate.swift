//
//  AppDelegate.swift
//  Chat On
//
//  Created by Vikas R S on 8/20/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Method to request for users notification
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(tokenRefreshNotification), name:
            NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound])
        { (isGranted, error) in
            
            if(error != nil)
            {
                print(error!)
            }
            else
            {
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                
                // Below code is added to remove warning UIApplication.registerForRemoteNotifications() must be used from main thread only
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        }
        
        FirebaseApp.configure()

        return true
    }
    
  // Whenever app is active there should be a direct connection between messaging service and the app
    func connectToFirebaseMessgaingService()
    {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        
        //To reduce power consumption or bandwidth consumption we should make this false when app goes to the background
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        connectToFirebaseMessgaingService()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @objc  func tokenRefreshNotification(_ notification: Notification)
    {
        var tokenStringValue:String = ""
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                
                tokenStringValue = result.token
                print("Remote instance ID token: \(result.token)")
            }
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFirebaseMessgaingService()
        updateUserInfo(token: tokenStringValue)
        
    }
    
    func updateUserInfo(token:String)
    {
        let VC:SignUpViewController = SignUpViewController()
        
        if (token.count != 0)
        {
            VC.postTheTokenToFireBaseDB(token:token)
        }
        
    }
    
 
    //Registration tokens are delivered via the method messaging:didReceiveRegistrationToken:. This method is called generally once per app start with an FCM token. When this method is called, it is the ideal time to:
    
//   1  If the registration token is new, send it to your application server.
//    2 Subscribe the registration token to topics. This is required only for new subscriptions or for situations where the user has re-installed the app.

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
    {
    
        updateUserInfo(token:fcmToken)

    }


}

