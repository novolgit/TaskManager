//
//  NotificationHandler.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 25.10.2023.
//

import Foundation
import UserNotifications
import UIKit

public class NotificationHandler: ObservableObject {
    // MARK: - Shared Instance
    /// The shared notification system for the process
    public static let shared = NotificationHandler()
    
    // MARK: - Properties
    /// Latest available notification
    @Published private(set) var latestNotification: UNNotificationResponse? = .none // default value
    
    // MARK: - Methods
    /// Handles the receiving of a UNNotificationResponse and propagates it to the app
    ///
    /// - Parameters:
    ///   - notification: The UNNotificationResponse to handle
    public func handle(notification: UNNotificationResponse) -> Array<UNNotificationPresentationOptions> {
        self.latestNotification = notification
        
        if UIDevice().checkIfHasDynamicIsland() {
            
            NotificationCenter.default.post(name: NSNotification.Name("NOTIFY"), object: nil, userInfo: ["content": notification.notification.request.content])
            return [.sound]
        } else {
            return [.sound, .banner]
        }
    }
}
