//
//  OffsetModifier.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 11.10.2023.
//

import SwiftUI

struct OffsetModifier: ViewModifier {
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader {proxy -> Color in
                    
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    
                    DispatchQueue.main.async {
                        withAnimation {
                            self.offset = minY
                        }
                    }
                    
                    return Color.clear
                }
            )
    }
}
