//
//  CalendarExtension.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 16.11.2023.
//

import Foundation

extension Calendar {
    static func numberOfDaysBetween(_ from: Date, _ to: Date) -> Int {
        let calendar = Calendar.current
        
        let fromDate = calendar.startOfDay(for: from)
        let toDate = calendar.startOfDay(for: to)
        let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
}
