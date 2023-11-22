//
//  CircleImage.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 10.10.2023.
//

import SwiftUI

struct CircleImage: View {
    let avatar: String
    
    var body: some View {
        Image(systemName: avatar)
            .clipShape(Circle())
            .overlay{
                Circle().stroke(.white, lineWidth: 2)
            }
            .shadow(radius: 3)
    }
}

#Preview {
    CircleImage(avatar: "person")
}
