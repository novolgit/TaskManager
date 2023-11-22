//
//  ArrayExtension.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 18.10.2023.
//

import Foundation

extension Array where Element == Int {
   func lowest() -> (value: Element, positions:[Index])? {
      guard !isEmpty else {return nil }  //you may wish to throw an error rather than return nil
      return indices.reduce( (value: Element.max, positions: [Index]() ) ) {
         switch self[$1] {
            case let x where x < $0.value: return (value: self[$1], positions:[$1])
            case let x where x > $0.value: return $0
            default: return ($0.value, $0.positions + [$1])
         }
      }
   }
}

extension Array<String> {
    static func getCustomCalendar() -> Array<String> {
        let customCalendar = Calendar(identifier: .gregorian)
        
        let firstWeekday = 2

        var symbols = customCalendar.shortWeekdaySymbols
        symbols = Array(symbols[firstWeekday-1..<symbols.count]) + symbols[0..<firstWeekday-1]
        
        return symbols
    }
}
