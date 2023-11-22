//
//  DateComponentsExtenstion.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 03.11.2023.
//

import Foundation

extension DateComponents {
    static func dateComponentsFromString(_ string: String) -> DateComponents {
        let  date = Date.stringToDate(string)
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        return components
    }
    
//    static func getAllWeekday(start: Date, end: Date) -> DateComponents {
//        let calendar = Calendar.current
//        
//        let firstDate = calendar.startOfDay(for: start)
//        let secondDate = calendar.startOfDay(for: end)
//        
//        let components = calendar.dateComponents([.day], from: firstDate, to: secondDate)
//        
//        return components
//    }
}
