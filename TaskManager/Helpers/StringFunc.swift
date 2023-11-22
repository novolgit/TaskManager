//
//  StringFunc.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 20.10.2023.
//

import Foundation

func getTitleText(from start: Date, to end: Date) -> AttributedString {
    let firstPart = start.twentyFourHourFormatted(.dateTime.hour(.defaultDigits(amPM: .narrow)).minute(),
                                                       hour: .defaultDigits(clock: .twentyFourHour, hourCycle: .zeroBased));
    
    let secondPart = end.twentyFourHourFormatted(.dateTime.hour(.defaultDigits(amPM: .narrow)).minute(),
                                                      hour: .defaultDigits(clock: .twentyFourHour, hourCycle: .zeroBased));
    
    let result = firstPart + " - " + secondPart
    
    return result
}
