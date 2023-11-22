//
//  StringExtension.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 05.10.2023.
//

import SwiftUI

extension String {
    
    static func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
    
    static func dateComponentToString(_ component: DateComponents) -> String?  {
        if let date = Calendar.current.date(from: component) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            let string = formatter.string(from: date)
            
            return string
        }
        return nil
    }
}
