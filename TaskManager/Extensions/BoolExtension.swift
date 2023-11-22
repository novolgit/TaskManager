//
//  BoolExtension.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 26.10.2023.
//

import Foundation

func isSameDay(date1: Date?, date2: Date?) -> Bool {
    if (date1 == nil || date2 == nil) {return false}
    return Calendar.current.isDate(date1!, inSameDayAs: date2!)
    
}
