//
//  AppModelContainer.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 21.11.2023.
//

import Foundation
import SwiftData

// MARK: - SwiftData Containers
var sharedModelContainer: ModelContainer = {
    let fullScheme = Schema([
        DataGeneration.self,
        
        GroupModel.self,
        TaskModel.self,

        Board.self,
        
        //
//        Account.self
    ])
    
    // cloudKitContainerIdentifier: "iCloud.com.novol.TaskManager"
    let modelConfiguration = ModelConfiguration(schema: fullScheme, cloudKitDatabase: .private("iCloud.com.novol.TaskManager"))
    
    do {
        return try ModelContainer(for: fullScheme, configurations: modelConfiguration)
    } catch {
        fatalError("Could not create ModelContainer: \(error.localizedDescription)")
    }
}()
