//
//  AppDelegate.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 25.10.2023.
//

import UIKit
import CloudKit
import UserNotifications
//import OneSignalFramework

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: - One Signal API
        // Remove this method to stop OneSignal Debugging
//        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
//        
//        // OneSignal initialization
//        OneSignal.initialize("aa2e0ced-ce14-4759-b1ed-f18914d76ba8", withLaunchOptions: launchOptions)
//        
//        // requestPermission will show the native iOS notification permission prompt.
//        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//        OneSignal.Notifications.requestPermission({ accepted in
//          print("User accepted notifications: \(accepted)")
//        }, fallbackToSettings: true)
        
        // MARK: - Register device for receiving Push Notifications
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        registerForPushNotifications()
        
        // MARK: - sigh in with Apple
//        var window: UIWindow?
//        
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//            switch credentialState {
//            case .authorized:
//                break // The Apple ID credential is valid.
//            case .revoked, .notFound:
//                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                DispatchQueue.main.async {
//                    self.window?.rootViewController?.showLoginViewController()
//                }
//            default:
//                break
//            }
//        }
        
        return true
    }
//    
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
//                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        let configuration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//        configuration.delegateClass = SceneDelegate.self
//        return configuration
//    }
}
// MARK:  Application Lifecycle methods
extension AppDelegate {
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
        // Saves changes in the application's managed object context before the application terminates.
    }
}
// MARK:  Notification methods
extension AppDelegate: UNUserNotificationCenterDelegate {
    /// Requests the user for Push Notification access
    private func registerForPushNotifications() {
        // Setting delegate to listen to events
        let center = UNUserNotificationCenter.current()
        /// Perform some notification registration magic !!!
        // Requesting access from user
        center.requestAuthorization(options: [.alert, .sound, .badge, .carPlay, .criticalAlert, .providesAppNotificationSettings]) { (granted, error) in
            // Checking if access is granted
            guard granted else { return }
            // Registering for remote notifications
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func getCurrentNotificationList() -> Array<UNNotificationRequest> {
        var newArray: Array<UNNotificationRequest> = []
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                newArray.append(request)
            }
        })
        
        return newArray
    
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// We receive the device token that we requested
        ///
        /// We save the device token to our local storage of choice
        ///
        /// (If needed) We register the device token with our FCM
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
         debugPrint("device token: \(token)")
    }
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        /// Some error occured while registering for device token
        debugPrint("notification err: \(error.localizedDescription)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        /// 1. Called when the user taps on a notification and the app is opened
        /// 2. Responds to the custom actions linked with the notifications (like categories and actions used for notifications)
//        NotificationHandler.shared.handle(notification: response)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        debugPrint("userNotificationCenter")
        /// Called when the app is in foreground and the notification arrives
//        completionHandler([.list, .banner, .sound])
//        return NotificationHandler.shared.handle(notification: notification)
        if UIDevice().checkIfHasDynamicIsland() {
            NotificationCenter.default.post(name: NSNotification.Name("NOTIFY"), object: nil, userInfo: ["content": notification.request.content])
            return [.sound]
        } else {
            return [.sound, .banner]
        }
    }
}
