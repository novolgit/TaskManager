//
//  DateExtension.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 03.10.2023.
//

import Foundation

// VerbatimHour option is Foundation private, so do this get at its option settings for all twentyFourHour options
extension Date.FormatStyle.Symbol.VerbatimHour {
    var isTwentyFourHour: Bool {
        [Date.FormatStyle.Symbol.VerbatimHour.twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased),
         .twoDigits(clock: .twentyFourHour, hourCycle: .oneBased),
         .defaultDigits(clock: .twentyFourHour, hourCycle: .zeroBased),
         .defaultDigits(clock: .twentyFourHour, hourCycle: .oneBased)
        ].contains(self)
    }
}

extension Date {
    static func stringToDate(_ stringDate: String?) -> Date {
        if (stringDate == nil) { return Date()}
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        let date = dateFormatter.date(from: stringDate!)
        
        return date ?? Date()
    }
    
    static func addDateInDate(date: Date, howMany: Int, type: String) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        switch(type) {
            case "day":
                dateComponents.day = howMany
            case "month":
                dateComponents.month = howMany
            case "year":
                dateComponents.year = howMany
            default:
                dateComponents.day = 0
        }
        
        let futureDate = calendar.date(byAdding: dateComponents, to: date)
        
        return futureDate ?? date
    }
    
    static func getAllWeekdays(start: Date, end: Date, selectedWeekdays: [Int]?, recallId: Int?) -> [Date] {
        let calendar = Calendar.current
        
        if selectedWeekdays != nil && selectedWeekdays!.count > 0 {
            let duration = Calendar.numberOfDaysBetween(start, end)
            
            let dateEnding = calendar.date(byAdding: .day, value: duration, to: start)!
            
            var matchingDates = [Date]()
            var components = DateComponents(hour: 0, minute: 0, second: 0)
            components.timeZone = TimeZone.current
            
            let startingAfter = calendar.date(byAdding: .day, value: -1, to: start)!
            
            calendar.enumerateDates(startingAfter: startingAfter, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
                if let date = date?.toLocalTime() {
                    if date <= dateEnding {
                        // weeks
                        if recallId! == 2  || recallId! == 5{
                            let weekDay = calendar.component(.weekday, from: date)
                            
                            if selectedWeekdays!.contains(weekDay) {
                                matchingDates.append(date)
                            }
                        }
                        // months
                        if recallId! == 3 {
                            let dayInMonth = calendar.component(.day, from: date)
                            let day = calendar.component(.day, from: start)
                            
                            if day == dayInMonth {
                                matchingDates.append(date)
                            }
                        }
                        // years
                        if recallId! == 4 {
                            let dayInYear = calendar.dateComponents([.month, .day], from: date)
                            let day = calendar.dateComponents([.month, .day], from: start)
                            
                            if day.day == dayInYear.day && day.month == dayInYear.month {
                                matchingDates.append(date)
                            }
                        }
                    } else {
                        stop = true
                    }
                }
            }
            
            debugPrint("Matching dates = \(matchingDates)")
            
            return matchingDates
        } else {
            
            let range = calendar.range(of: .day, in: .year, for: start)
            
            return range!.compactMap{ day -> Date? in
                return calendar.date(byAdding: .day, value: day - 1, to: start)!
            }
        }
    }
    
    /// Format this Date in twenty four hour format
    /// - Parameters:
    ///   - formatStyle: FormatStyle to format this Date. Should have hour part. If in AM/PM style, the hour is changed to 24-hour
    ///   - hour: how the hour should be formatted in 24-hour format
    /// - Returns: the result in an AttributedString
    func twentyFourHourFormatted(_ formatStyle: Date.FormatStyle, hour: Date.FormatStyle.Symbol.VerbatimHour) -> AttributedString {
        func scan(_ s: AttributedString) -> (Range<AttributedString.Index>?, Range<AttributedString.Index>?, Range<AttributedString.Index>?) {
            var hourRange: Range<AttributedString.Index>?
            // remember the range preceding AM/PM to remove only if it's a space
            var precedingAMPMRange: Range<AttributedString.Index>?
            var amPMRange: Range<AttributedString.Index>?
            var previousRun: AttributedString.Runs.Run?
            for r in s.runs {
                if s[r.range].dateField == .hour {
                    hourRange = r.range
                } else if s[r.range].dateField == .amPM {
                    amPMRange = r.range
                    // only remove if preceding run is not a `dateField`, (only remove space which is `Foundation.AttributedString._InternalRun`)
                    if previousRun?.dateField == nil {
                        precedingAMPMRange = previousRun?.range
                    }
                    // hour field always precede amPM?, so all done?
                    break
                }
                previousRun = r
            }
            return (hourRange, precedingAMPMRange, amPMRange)
        }

        assert(hour.isTwentyFourHour)
        var result = formatted(formatStyle.attributed)
        let (hourRange, precedingAMPMRange, amPMRange) = scan(result)
        let twentyFourHour = formatted(Date.VerbatimFormatStyle(format: "\(hour: hour)",
                                                                timeZone: formatStyle.timeZone,
                                                                calendar: formatStyle.calendar).attributed
        )
        if let hourRange = hourRange {
            // if there is AM/PM, remove it and its preceding delimiter
            // must remove in the order from end to start, otherwise index out-of-range!
            if let amPMRange = amPMRange {
                result.removeSubrange(amPMRange)
            }
            if let precedingAMPMRange = precedingAMPMRange {
                result.removeSubrange(precedingAMPMRange)
            }

            // fix up the hour field to twenty four hour format:
            result.replaceSubrange(hourRange, with: twentyFourHour)
        }
        return result
    }
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
//        calendar.firstWeekday = 2
        
        // geting start date
        let startDate = startOfMonth
        
        let range = calendar.range(of: .day, in: .month, for: startDate)
        
        // getting date...
        return range!.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
        
    }
    
    func getAllWeekDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = startOfDay
        
        var dayOfWeek = calendar.component(.weekday, from: startDate)
        
        dayOfWeek += 6
        if (dayOfWeek > 7) {
            dayOfWeek -= 7
        }
        
        let range = calendar.range(of: .weekday, in: .weekOfYear, for: startDate)
        
        let dates = range!.compactMap { day -> Date in
            calendar.date(byAdding: .day, value: day - dayOfWeek, to: startDate)!
            }
//            .filter { !calendar.isDateInWeekend($0) }
        
        
        return dates
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self).toLocalTime()
    }
    
    func getStart(of component: Calendar.Component, calendar: Calendar = Calendar.current) -> Date? {
        return calendar.dateInterval(of: component, for: self)?.start
    }

    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return calendar.date(from: components)!.toLocalTime()
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
    
    func toLocalTime() -> Date {
        let timezone    = TimeZone.current
        let seconds     = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
