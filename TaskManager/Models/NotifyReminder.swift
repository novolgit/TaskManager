//
//  NotifyReminder.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 03.11.2023.
//

import Foundation

struct NotifyReminder: Identifiable, Hashable, Codable {
    static let types = ["At the moment", "5 minutes", "10 minutes", "30 minutes", "1 hour", "2 hour", "1 day"]
    
    static var notifyReminders = [
        NotifyReminder(id: 0, title: "At the moment"),
        NotifyReminder(id: 1, title: "5 minutes"),
        NotifyReminder(id: 2, title: "10 minutes"),
        NotifyReminder(id: 3, title: "30 minutes"),
        NotifyReminder(id: 4, title: "1 hour"),
        NotifyReminder(id: 5, title: "2 hour"),
        NotifyReminder(id: 6, title: "1 day")
    ]
    
    var id: Int
    var title: String
}
