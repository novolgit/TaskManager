//
//  ViewExtension.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 19.10.2023.
//

import SwiftUI

extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)

                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
//                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    /// Mark: - 
    func onNotification(perform action: @escaping (UNNotificationResponse) -> Void) -> some View {
        modifier(NotificationViewModifier(onNotification: action))
    }
}

