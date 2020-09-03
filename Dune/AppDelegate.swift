//
//  AppDelegate.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import OneSignal
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let _: OSHandleNotificationReceivedBlock = { notification in
            print("Received Notification: \(String(describing: notification!.payload.notificationID))")
         }

        let _: OSHandleNotificationActionBlock = { result in
             // This block gets called when the user reacts to a notification received
             let payload: OSNotificationPayload = result!.notification.payload

             var fullMessage = payload.body
             print("Message = \(String(describing: fullMessage))")

             if payload.additionalData != nil {
                 if payload.title != nil {
                     let messageTitle = payload.title
                    print("payload.category \(String(describing: payload.category))")
                    print("payload.subtitle \(String(describing: payload.subtitle))")
                     print("Message Title = \(messageTitle!)")
                 }

                 let additionalData = payload.additionalData
                 if additionalData?["actionSelected"] != nil {
                     fullMessage = fullMessage! + "\nPressed ButtonID: \(String(describing: additionalData!["actionSelected"]))"
                 }
             }
         }
        
        let oneSignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
       
        OneSignal.setRequiresUserPrivacyConsent(true);
        OneSignal.initWithLaunchOptions(launchOptions,
          appId: "9f5a5e7b-642b-4e21-abf3-c2cacda049bf",
          handleNotificationAction: nil,
          settings: oneSignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        if #available(iOS 13.0, *) { } else {
            let launchScreen = LaunchVC()
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = launchScreen
            self.window!.makeKeyAndVisible()
        }
        
        return true
    }
        
    func promptForPushNotifications(completion: @escaping (Bool) -> ()) {
        OneSignal.consentGranted(true)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            UserDefaults.standard.set(true, forKey: "askedPermissionForNotifications")
            UserDefaults.standard.set(accepted, forKey: "allowedNotifications")
            print("User accepted notifications: \(accepted)")
            if accepted {
                OneSignal.sendTags([ "username" : User.username! ])
            }
            completion(accepted)
        })
    }
    
    override init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)        
        FirebaseApp.configure()
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
          print("4")
        if let incomingURL = userActivity.webpageURL{
            print("Incoming URL (Delegate): \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                if error != nil {
                    print("Error with incoming link: \(error!.localizedDescription) ")
                    return
                }
                if let dynamicLink = dynamicLink {
                    DynamicLinkHandler.handleIncomingLink(dynamicLink) { program in
                        //
                    }
                }
            }
            return linkHandled
        } else {
            return false
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            DynamicLinkHandler.handleIncomingLinkOnOpen(dynamicLink)
            return true
        } else {
            return false
        }
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

extension AppDelegate {

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //use response.notification.request.content.userInfo to fetch push data
    }

    // for iOS < 10
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        //use notification.userInfo to fetch push data
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //use userInfo to fetch push data
    }
}


