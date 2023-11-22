//
//  TimeIntervalExtension.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 21.11.2023.
//

import Foundation

extension TimeInterval {
    public func getTimeRange(_ start: Date, _ end: Date) -> TimeInterval {
        let minutes = end.minutes(from: start)
        
        return TimeInterval(minutes)
    }
}
