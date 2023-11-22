//
//  BoardsView.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 16.11.2023.
//

import SwiftUI
import SwiftData

struct BoardsView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var boards: [Board]
    
    @Binding var currentBoard: UUID
    
    var body: some View {
        Picker("", selection: $currentBoard) {
            ForEach(boards, id: \.self) {
                Text($0.name)
                    .font(.title)
                    .foregroundStyle(Color("FTextColor"))
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
}

#Preview {
    BoardsView(currentBoard: .constant(.init()))
}
