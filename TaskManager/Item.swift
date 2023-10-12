//
//  Item.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 12.10.2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
