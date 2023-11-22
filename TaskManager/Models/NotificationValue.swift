//
//  NotificationValue.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 02.11.2023.
//

import Foundation
import UserNotifications

struct NotificationValue: Identifiable {
    var id: String = UUID().uuidString
    var content: UNNotificationContent
    var dateCreated: Date = Date()
    var showNotification: Bool = false
    
}
