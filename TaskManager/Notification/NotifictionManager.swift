//
//  NotifictionManager.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 25.10.2023.
//

import Foundation
import UserNotifications

class NotificationManager {
    let likeActionIcon = UNNotificationActionIcon(systemImageName: "hand.thumbsup") // 👍🏻
    let likeAction = UNNotificationAction(identifier: "like-action",
                                               title: "Like",
                                             options: [],
                                                icon: UNNotificationActionIcon(systemImageName: "hand.thumbsup"))
            
    let commentActionIcon = UNNotificationActionIcon(templateImageName: "text.bubble") // 💬
    let commentAction = UNTextInputNotificationAction(identifier: "comment-action",
                                                           title: "Comment",
                                                         options: [],
                                                            icon: UNNotificationActionIcon(templateImageName: "text.bubble"),
                                            textInputButtonTitle: "Post",
                                            textInputPlaceholder: "Type here…")

    let category = UNNotificationCategory(identifier: "update-actions",
                                             actions: [UNNotificationAction(identifier: "like-action",
                                                                            title: "Like",
                                                                          options: [],
                                                                             icon: UNNotificationActionIcon(systemImageName: "hand.thumbsup"))
                                                       , UNTextInputNotificationAction(identifier: "comment-action",
                                                                                                 title: "Comment",
                                                                                               options: [],
                                                                                                  icon: UNNotificationActionIcon(templateImageName: "text.bubble"),
                                                                                  textInputButtonTitle: "Post",
                                                                                  textInputPlaceholder: "Type here…")],
                                   intentIdentifiers: [], options: [])
}
