//
//  NotificationPreview.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 30.10.2023.
//

import SwiftUI

struct NotificationPreview: View {
    var size: CGSize
    var value: NotificationValue
    @Binding var notifications: [NotificationValue]
    var body: some View {
        HStack {
            if let image = UIImage(named: "testPushIcon") {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            
            VStack (alignment: .leading, spacing: 4) {
                Text(value.content.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("SecondBackground"))
                Text(value.content.body)
                    .font(.caption)
                    .foregroundStyle(Color("SecondBackground").opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .padding(.horizontal, 12)
        .padding(.vertical, 18)
        
        .blur(radius: value.showNotification ? 0 : 30)
        .opacity(value.showNotification ? 1 : 0)
        .scaleEffect(value.showNotification ? 1 : 0.5, anchor: .top)
        
        .frame(width: value.showNotification ? size.width - 22: 126, height: value.showNotification ? nil : 37.33)
        .background {
            RoundedRectangle(cornerRadius: value.showNotification ? 50 : 63, style: .continuous)
                .fill(Color("Primary"))
        }
//        .scaleEffect(1.1)
        .clipped()
        .offset(y: 11)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: value.showNotification)
        // MARK: remove notification from array
        .onChange(of: value.showNotification) { oldValue, newValue in
            if newValue && notifications.indices.contains(index) {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if notifications.indices.contains(index + 1) {
                        notifications[index + 1].showNotification = true
                    }
                    
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        notifications[index].showNotification = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if notifications.indices.contains(index + 1) {
                                    notifications[index + 1].showNotification = true
                                }
                            }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            notifications.remove(at: index)
                        }
                    }
                }
            }
        }
        // MARK: show animation
        .onAppear {
            if index == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    notifications[index].showNotification = true
                }
            }
        }
    }
    
    var index: Int {
        return notifications.firstIndex { CValue in
            CValue.id == value.id
        } ?? 0
    }
}
