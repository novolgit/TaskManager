//
//  LoggerExtension.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 19.11.2023.
//

import os.log

extension Logger {
    
    static let loggingSubsystem: String = "com.apple.samples.cloudkit.SyncEngine"
    
    static let ui = Logger(subsystem: Self.loggingSubsystem, category: "UI")
    static let database = Logger(subsystem: Self.loggingSubsystem, category: "Database")
    static let dataModel = Logger(subsystem: Self.loggingSubsystem, category: "DataModel")
}
