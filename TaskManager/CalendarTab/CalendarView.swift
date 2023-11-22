//
//  CalendarView.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 14.09.2023.
//

import SwiftUI
import Foundation

struct CalendarView: View {
    @Namespace private var animation
    
    @Binding var currentDate: Date
//    @Binding var offset: CGFloat
    
    @State var isCollapsed: Bool = true
    @State var index: Int = 0
    @State var showDate: Date = Date().toLocalTime()
    
    var body: some View {
        VStack(spacing: 35) {
            HStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(extraDate()[1])
                        .font(.title.bold())
                }
                
                Spacer()
                
                Button {
                    if !isCollapsed {
                        changeShowDate(minus: true, isWeek: false)
                    } else {
                        changeShowDate(minus: true, isWeek: true)
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2 )
                }
                
                Button {
                    if !isCollapsed {
                        changeShowDate(minus: false, isWeek: false)
                    } else {
                        changeShowDate(minus: false, isWeek: true)
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 0) {
                ForEach(Array.getCustomCalendar(), id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()) { value in
                    let innerData: Array<Bool> = [isSameDay(date1: value.date, date2: currentDate), isSameDay(date1: value.date, date2: Date())]
                    let textColor: Color = innerData[0] ? Color("Background") : Color("Primary").opacity(getCardOpacity(value.date))
                    
                    CalendarCardView(sort: SortDescriptor(\TaskModel.date), date: value.date, isSameDay: innerData[0], value: value, textColor: textColor)
                        .background(content: {
                            if innerData[0] {
                                    Capsule()
                                        .fill(Color("Primary"))
                                        .padding(.horizontal, 8)
//                                            .matchedGeometryEffect(id: "CALENDARTABANIMATION", in: animation)
                            }
                            if innerData[1] {
                                Capsule()
                                    .stroke(Color("Primary"), lineWidth: 1)
                                    .padding(.horizontal, 8)
//                                        .matchedGeometryEffect(id: "CALENDARTABANIMATION", in: animation)
                            }
                        })
                        .onTapGesture {
//                                withAnimation(.bouncy) {
                                currentDate = value.date
//                                }
                        }
                }
            }
//            }
//                .frame(height: 300)
//            }
            
            Button {
                withAnimation(.bouncy) {
                    isCollapsed = !isCollapsed
                    showDate = currentDate
                }
            } label: {
                Image(systemName: isCollapsed ? "chevron.down" : "chevron.up")
                    .foregroundColor(Color("Primary"))
                    .symbolEffect(.bounce.up.byLayer, value: isCollapsed)
            }
            .padding(.zero)

            
//            TasksView(task: $entries)
            
//            VStack(spacing: 15) {
//                Text("Tasks")
//                    .font(.title2.bold())
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.vertical , 20)
//
////                if let task = tasks.first(where: { task in
////                    return isSameDay(date1: task.taskDate, date2: currentDate)
////                }) {
//
//                    ForEach(task.task) { task in
//                        TodayContainerView(text: task.title, date: task.time)
//                    }
//                }
////                else {
////                    Text("No Task Found")
////                }
//            }
//            .padding()

            
        }
//        .onChange(of: currentMonth) {oldValue, newValue in
//            // update month or week
//            currentDate = getCurrentMonth()
//            print("current date from changes of months \(currentDate)")
//        }
//        .onChange(of: currentWeek) {oldValue, newValue in
//            // update month or week
//            currentDate = getCurrentWeek()
//            print("current date from changes of week \(currentDate)")
//        }
    }
    
    func changeShowDate(minus: Bool, isWeek: Bool) -> Void {
        let calendar = Calendar.current
        
        if let futureDate = calendar.date(byAdding: isWeek ? .weekOfMonth : .month, value: minus ? -1 : 1, to: showDate) {
            
            //        guard let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) else {}
            
            showDate = futureDate
        }
    }
    
    func getCardOpacity(_ date: Date) -> CGFloat {
        let result: Bool = isCollapsed && !isCurrentMonth(date)
        
        return result ? 0.5 : 1.0
    }
    
    func isCurrentMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.dateComponents([.month], from: currentDate).month == calendar.dateComponents([.month], from: date).month
    }
    
    // Extraing year and month for display
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: showDate)
         
        return date.components(separatedBy: " ")
    }
    
//    func getCurrentMonth() -> Date {
//        let calendar = Calendar.current
//        
//        // Getting Current month date
//        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: currentDate) else {
//            return Date()
//        }
//        
//        return currentMonth
//    }    
//    
//    func getCurrentWeek() -> Date {
//        let calendar = Calendar.current
//        
//        // Getting Current week date
//        guard let currentWeek = calendar.date(byAdding: .weekOfMonth, value: self.currentWeek, to: currentDate) else {
//            return Date()
//        }
//        
//        return currentWeek
//    }
    
    func extractDate() -> [DateValue] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        var days =
            isCollapsed
            ?
        showDate.getAllWeekDates().compactMap { date -> DateValue in
                let day = calendar.component(.day, from: date)
                let dateValue =  DateValue(day: day, date: date)
                return dateValue
            }
            : 
        showDate.getAllDates().compactMap { date -> DateValue in
                let day = calendar.component(.day, from: date)
                let dateValue =  DateValue(day: day, date: date)
                return dateValue
            }

        
//        // adding offset days to get exact week day...
        var firstWeekday = calendar.component(.weekday, from: days.first!.date)
        
        firstWeekday += 6
        if (firstWeekday > 7) {
            firstWeekday -= 7
        }
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
}


#Preview {
    CalendarView(currentDate: .constant(Date.now), isCollapsed: false)
}


func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
