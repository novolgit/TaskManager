//
//  TasksSearchSuggestions.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 21.11.2023.
//

import SwiftUI
import SwiftData

struct TasksSearchSuggestions: View {
    @Query private var tasks: [TaskModel]
    
    var names: [String] {
        Set(tasks.map(\.name)).sorted()
    }
    
    var body: some View {
        ForEach(names, id: \.self) { name in
            Text("**\(name)**")
                .searchCompletion(name)
        }
    }
}
