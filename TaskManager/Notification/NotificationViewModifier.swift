//
//  NotificationViewModifier.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 25.10.2023.
//

import SwiftUI

struct NotificationViewModifier: ViewModifier {
    // MARK: - Private Properties
    private let onNotification: (UNNotificationResponse) -> Void
 
    // MARK: - Initializers
    init(onNotification: @escaping (UNNotificationResponse) -> Void) {
        self.onNotification = onNotification
    }
 
    // MARK: - Body
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationHandler.shared.$latestNotification) { notification in
                guard let notification else { return }
                onNotification(notification)
            }
    }
}
