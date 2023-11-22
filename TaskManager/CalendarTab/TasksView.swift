//
//  TasksView.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 18.09.2023.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Query private var tasks: [TaskModel]
    
    init(sort: SortDescriptor<TaskModel>, date: Date) {
        let calendar = Calendar.current
        
        let start = calendar.startOfDay(for: date).toLocalTime()
        let end = calendar.startOfDay(for: date + 86399.0).toLocalTime()
        
        _tasks = Query(filter: #Predicate {
            $0.date >= start && $0.date <= end
        }, sort: [sort])
    }
    
    @State var isTimeLineLook: Bool = true
    
    var body: some View {
        if (tasks.count > 0) {
            VStack {
                HStack {
                    Text("Tasks")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                    Spacer()
                    
                    VStack {
                        Button {
                            withAnimation {
                                isTimeLineLook.toggle()
                            }
                        } label: {
                            Label("", systemImage: isTimeLineLook ? "calendar.day.timeline.left" : "list.bullet.below.rectangle")
                        }
                        .contentTransition(.symbolEffect(.replace))
                    }
                }
                TimeLineListView(tasks: tasks)
                //            TodayListView()
                //                .padding(.horizontal, 15)
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    TasksView(sort: SortDescriptor(\TaskModel.date), date: Date.now)
}

