//
//  ContentView.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 12.10.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var notifications: [NotificationValue] = []
    
    var body: some View {
//        TabView {
            CalendarTabView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .top) {
                GeometryReader {proxy in
                    let size = proxy.size
                    
                    ForEach(notifications) { notification in
                        NotificationPreview(size: size, value: notification, notifications: $notifications)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                
                }
                .ignoresSafeArea()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NOTIFY"))) { output in
                if let content = output.userInfo?["content"] as? UNNotificationContent {
                    let newNotification = NotificationValue(content: content)
                    notifications.append(newNotification)
                }
            }
//                .tabItem {
//                    Label("Calendar", systemImage: "square.and.pencil")
//                }
//            
//            Text("nothing")
//                .tabItem {
//                    Label("Calendar", systemImage: "square")
//                }
//        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskModel.self, inMemory: true)
}
