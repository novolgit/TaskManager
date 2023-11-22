//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 12.10.2023.
//

import SwiftUI
import SwiftData

@main
struct TaskManagerApp: App {
    // MARK: - AppDelegates
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
