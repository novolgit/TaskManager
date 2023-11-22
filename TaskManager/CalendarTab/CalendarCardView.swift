//
//  CalendarCardView.swift
//  manage
//
//  Created by Влад Новолоакэ on 08.10.2023.
//

import SwiftUI
import SwiftData

struct CalendarCardView: View {
    @Query private var tasks: [TaskModel]
    
    let isSameDay: Bool
    
    let value: DateValue
    
    let textColor: Color
    
    init(sort: SortDescriptor<TaskModel>, date: Date, isSameDay: Bool, value: DateValue, textColor: Color) {
        let calendar = Calendar.current
        
        let start = calendar.startOfDay(for: date).toLocalTime()
        let end = calendar.startOfDay(for: date + 86399.0).toLocalTime()
        
        _tasks = Query(filter: #Predicate {
            $0.date >= start && $0.date <= end
        }, sort: [sort])
        
        self.value = value
        self.isSameDay = isSameDay
        self.textColor = textColor
    }
    
    var body: some View {
        VStack {
            
            if value.day != -1 {
                
//                let filteredTasks = tasks.first(where: { task in
//                    return isSameDay(date1: task.date, date2: value.date)
//                })
                
                Text("\(value.day)")
                    .font(.title3.bold())
                    .foregroundColor(textColor)
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                //                if (filteredTasks != nil) {
                //                    Text("\(filteredTasks!)")
                //                }
                
                if (tasks.count > 0) {
                    if (tasks.count > 3) {
                        Text("•\(tasks.count)")
                            .font(.footnote)
                            .fontWeight(.heavy)
                            .foregroundStyle(textColor)
                    } else {
                        HStack(spacing: 2) {
                            ForEach(tasks) {task in
                                Circle()
                                    .fill(isSameDay ? Color("Background") : Helper.getColorByType(type: task.name))
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .padding(.vertical, 11)
        .frame(height: 70, alignment: .top)
    }
}

//#Preview {
//    CalendarCardView()
//}
