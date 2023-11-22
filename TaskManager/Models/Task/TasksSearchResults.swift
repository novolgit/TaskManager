//
//  TasksSearchResults.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 21.11.2023.
//

import SwiftUI
import SwiftData

struct TasksSearchResults<Content: View>: View {
    @Binding var searchText: String
    @Query private var tasks: [TaskModel]
    private var content: (TaskModel) -> Content
    
    init(searchText: Binding<String>, date: Date, isSameDay: Bool, @ViewBuilder content: @escaping (TaskModel) -> Content) {
        let calendar = Calendar.current
        
        let start = calendar.startOfDay(for: date).toLocalTime()
        let end = calendar.startOfDay(for: date + 86399.0).toLocalTime()
        
        _searchText = searchText
        _tasks = Query(filter: #Predicate {
            $0.date >= start && $0.date <= end
        }, sort: \.date)
        self.content = content
    }
    
    var body: some View {
        if $searchText.wrappedValue.isEmpty {
            ForEach(tasks, content: content)
        } else {
            ForEach(tasks.filter {
                $0.name.contains($searchText.wrappedValue)
            }, content: content)
        }
    }
}
