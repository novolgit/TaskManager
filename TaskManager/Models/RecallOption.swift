//
//  RecallOption.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 03.11.2023.
//

import Foundation

struct RecallOption: Identifiable, Hashable, Codable {
    static let types = ["None", "Every day", "Every week", "Every month", "Every year"]
    
    static var recallOptions = [
        RecallOption(id: 0, title: "None"),
        RecallOption(id: 1, title: "Every day"),
        RecallOption(id: 2, title: "Every week"),
        RecallOption(id: 3, title: "Every month"),
        RecallOption(id: 4, title: "Every year"),
        RecallOption(id: 5, title: "Custom"),
    ]
    
    var id: Int
    var title: String
}
