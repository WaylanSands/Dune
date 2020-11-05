//
//  AppDelegate.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import CloudKit
import Firebase
import FirebaseCrashlytics
import FirebaseMessaging
import FirebaseFirestore
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) { } else {
            let launchScreen = LaunchVC()
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = launchScreen
            self.window!.makeKeyAndVisible()
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        FireStoreManager.addVersionControl()
        Messaging.messaging().delegate = self
        return true
    }
        
    func promptForPushNotifications(completion: @escaping (Bool) -> ()) {
        UserDefaults.standard.set(true, forKey: "askedPermissionForNotifications")
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { granted, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    completion(granted)
                }
            }
        })
        
        print("Prompted")
    }
    
    func newVersionAlert(alert: CustomAlertView) {
         UIApplication.shared.windows.last?.addSubview(alert)
    }
    
    override init() {
//        FirebaseConfiguration.shared.setLoggerLevel(.min)
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
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
        switch dunePlayBar.currentState {
        case .playing, .paused:
            User.appendPlayedEpisode(ID: dunePlayBar.episode.ID , progress: dunePlayBar.currentProgress)
        default:
            break
        }
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
}

extension AppDelegate: MessagingDelegate {
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Hello \(userInfo)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Hello two \(userInfo)")

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo

        // Print full message.
         print("Hello three \(userInfo)")

        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }

    //When clicked
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.


        // Print full message.
        print("Hello four \(userInfo)")
        //You can here parse it, and redirect.
        completionHandler()
    }
    
}



