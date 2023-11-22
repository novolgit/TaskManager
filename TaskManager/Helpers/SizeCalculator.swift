//
//  SizeCalculator.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 04.10.2023.
//

import SwiftUI

struct SizeCalculator: ViewModifier {
    
    @Binding var size: SizeModel
    let id: Int
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            size.size = proxy.size
                            size.id = id
                        }
                }
            )
    }
}

extension View {
    func saveSize(id: Int, in size: Binding<Array<SizeModel>>) -> some View {
        modifier(SizeCalculator(size: size[id], id: id))
    }
}

struct SizeModel {
    var id: Int
    var size: CGSize
}
