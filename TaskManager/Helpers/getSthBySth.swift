//
//  getSthBySth.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 26.10.2023.
//

import UserNotifications
import SwiftUI

class Helper {
    static func getColorByType(type: String) -> Color {
        switch(type) {
        case "alert":
            return Color(.systemPink)
        case "importance":
            return Color(.systemOrange)
        case "critical":
            return Color(.red)
        case "weak":
            return Color(.systemGray)
        default:
            return Color(.blue)
        }
    }
    
    static func getColorByStatus(givenStatus: String) -> Color {
        switch(givenStatus) {
        case "default":
            return Color.blue
        case "importance":
            return Color.orange
        case "critical":
            return Color.red
        case "weak":
            return Color.gray
        default:
            return Color.blue
        }
    }
    
    static func getIconByPushType(givenPushType: Bool) -> String {
        switch(givenPushType) {
        case false:
            return "bell"
            //    case "mute":
            //        return "bell.slash"
        case true:
            return "light.beacon.min"
        default:
            return "bell"
        }
    }
    
    static func getTitleByPushType(givenPushType: Bool) -> String {
        switch(givenPushType) {
        case false:
            return "default"
            //    case "mute":
            //        return "bell.slash"
        case true:
            return "critical"
        default:
            return "default"
        }
    }
    
    static func getNotificationSoundByPushType(givenPushType: Bool) -> UNNotificationSound {
        switch(givenPushType) {
        case false:
            return UNNotificationSound.default
        case true:
            return UNNotificationSound.defaultCritical
        default:
            return UNNotificationSound.default
        }
    }
    
    static func getRemindTimeByID(_ id: Int) -> DateComponents {
        switch(id) {
        case 0:
            return DateComponents(minute: 0)
        case 1:
            return DateComponents(minute: 5)
        case 2:
            return DateComponents(minute: 10)
        case 3:
            return DateComponents(minute: 30)
        case 4:
            return DateComponents(minute: 60)
        case 5:
            return DateComponents(minute: 120)
        case 6:
            return DateComponents(minute: 60 * 24)
        default:
            return DateComponents(minute: 0)
        }
    }
    
    static func getRecallByID(_ id: Int) -> DateComponents {
        switch(id) {
        case 0:
            return DateComponents(minute: 0)
        case 1:
            return DateComponents(day: 1)
        case 2:
            return DateComponents(day: 7)
        case 3:
            return DateComponents(month: 1)
        case 4:
            return DateComponents(year: 1)
        default:
            return DateComponents(minute: 0)
        }
    }
}
