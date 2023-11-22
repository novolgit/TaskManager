//
//  TimeLineListView.swift
//  manage
//
//  Created by Влад Новолоакэ on 18.09.2023.
//

import SwiftUI

struct TimeLineListView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var startHour: Int?
    @State private var positionList: Array<Int> = []
    @State private var isPresentedEventCard: Bool = false
    @State private var selection: UUID? = nil
    @State private var isDeleting: Bool = false
    @State private var editView: Bool = false
    
    let tasks: [TaskModel]
    
    private static let lineWidth: CGFloat = 2
    private static let dotDiameter: CGFloat = 8
    
    // MARK: - sizes
    private let leadingWidth: CGFloat = 50
    private let trailingWidth: Int = 10
    
    private let hourHeight: CGFloat = 120
    @State private var hourWidth: CGFloat = (UIScreen.main.bounds.width - 50) / 2
    
    //    let dateFormatter: DateFormatter
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(getRange(), id: \.self) { hour in
                    // hide contains dates
//                    let show: Bool = {
//                        
//                        for task in tasks {
//                            let range: ClosedRange<Date> = task.start...task.start.addingTimeInterval(600 * 2)
//                            let dateByHour: Date = {
//                                var components = DateComponents()
//                                components.hour = Int(hour)
//                                components.minute = 0
//                                let date = Calendar.current.date(from: components)
//                                
//                                return date ?? Date.now
//                            }()
//                            
//                            print("range \(range)")
//                            print("dateByHour \(dateByHour)")
//                            
//                            if range.contains(dateByHour) {
//                                return false
//                            }
//                        }
////                            if Calendar.current.dateComponents(.hour, from: .task.start) {
////                                return false
////                            }
//                        
//                        return true
//                    }()
                    
                    HStack {
                        
                        Text("\(hour):00")
                            .font(.caption)
                            .frame(width: 40, alignment: .trailing)
                        
                        DottedLine()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .frame(height: 1)
                            .foregroundColor(.gray).opacity(0.5)
                    }
                    .frame(height: hourHeight)
                }
            }
            
//            VStack(alignment: .leading, spacing: 0) {
            // MARK: - red lines on tasks
//                ForEach(tasks) { task in
//                    let calendar = Calendar.current
//                    
//                    // start
//                    let start = task.start.twentyFourHourFormatted(.dateTime.hour(.defaultDigits(amPM: .narrow)).minute(),
//                                                                       hour: .defaultDigits(clock: .twentyFourHour, hourCycle: .zeroBased))
//                    
//                    let startMinute = calendar.component(.minute, from: task.start)
//                    let offsetY = offsetYCalculate(start: calendar.component(.hour, from: task.start), startMinute: startMinute)
//                    
//                    // finish
//                    let finish = task.end.twentyFourHourFormatted(.dateTime.hour(.defaultDigits(amPM: .narrow)).minute(),
//                                                                       hour: .defaultDigits(clock: .twentyFourHour, hourCycle: .zeroBased))
//                    
//                    let duration = calendar.dateComponents([.minute], from: task.start, to: task.end)
//                    let height = CGFloat(duration.minute ?? 0) * (hourHeight / 60)
//                    
//                    HStack {
//                        Text("\(start)")
//                            .font(.caption)
//                            .frame(width: 40, alignment: .trailing)
//                        
//                        DottedLine()
//                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
//                            .frame(height: 1)
//                            .foregroundColor(.red).opacity(0.5)
//                    }
//                    .offset(y: offsetY + (hourHeight / 2) - /*cornerRadius*/ 5 - /*padding*/ 2)
//                    
//                    HStack {
//                        Text("\(finish)")
//                            .font(.caption)
//                            .frame(width: 40, alignment: .trailing)
//                        
//                        DottedLine()
//                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
//                            .frame(height: 1)
//                            .foregroundColor(.red).opacity(0.5)
//                    }
//                    .offset(y: offsetY + (height == 0 ? 60 : height))
////                    HStack {
////                        
////                        Text("\(task.start)")
////                            .font(.caption)
////                            .frame(width: 40, alignment: .trailing)
////                        
////                        DottedLine()
////                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
////                            .frame(height: 1)
////                            .foregroundColor(.red).opacity(0.5)
////                    }
////                    .frame(height: hourHeight)
////                }
//            }
        
            
            ForEach(Array(zip(tasks.indices, tasks)), id: \.0) { index, task in
                rowAt(task: task, position: positionList.indices.contains(index) == true ? positionList[index] : 0)
            }
        }
        .onChange(of: tasks) {
            if (tasks.count > 0) {
                getStartHour()
                getPosition()
            }
        } 
        .onAppear {
            if (tasks.count > 0) {
                getStartHour()
                getPosition()
            }
        }
    }
    
    @ViewBuilder
    private func rowAt(task: TaskModel, position: Int) -> some View {
        let calendar = Calendar.current
        
        let duration = calendar.dateComponents([.minute], from: task.start, to: task.end)
        let height = CGFloat(duration.minute ?? 0) * (hourHeight / 60)
        
        let startMinute = calendar.component(.minute, from: task.start)
        
        let offsetY = offsetYCalculate(start: calendar.component(.hour, from: task.start), startMinute: startMinute)
        let offsetX = hourWidth * CGFloat(position - 1)
        
        let cornerRadius: CGFloat = 10
        
        let repeatedTask: () -> Bool = {
            return task.group != nil
        }
        
        VStack {
            NavigationLink(destination: EventCardDetailView(task: task, editMode: $editView), tag: task.id, selection: $selection) {
                //
                //        VStack(alignment: .leading) {
                //            HStack {
                //                Text(task.date.twentyFourHourFormatted(.dateTime.hour(.defaultDigits(amPM: .narrow)).minute(),
                //                                                           hour: .defaultDigits(clock: .twentyFourHour, hourCycle: .zeroBased)))
                ////                TODO: avatars of contributors
                //                ForEach(["person", "person.fill"], id: \.self) {avatar in
                //                    CircleImage(avatar: avatar)
                //                }
                //            }
                //            Text(task.name).bold()
                //        }
                //        .frame(width: 90)
                //        .font(.caption)
                //        .padding(4)
                //        .background(
                //            RoundedRectangle(cornerRadius: 8)
                //                .fill(getColorByStatus(givenStatus: task.status ?? "")).opacity(0.5)
                //        )
                //        .frame(minHeight: 60, idealHeight: height == 0 ? 60 : height, maxHeight: height == 0 ? 60 : height, alignment: .bottom)
            }
            
            EventCardView(task: task, fillColor: Helper.getColorByStatus(givenStatus: task.status), hourWidth: hourWidth, hourHeight: height == 0 ? 60 : height, cornerRadius: cornerRadius, icon: Helper.getIconByPushType(givenPushType: task.pushType), repeatedTask: repeatedTask())
                .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: cornerRadius))
                .contextMenu {
                    Group {
                        Button(action: {
                            // TODO:
                        }) {
                            Label{
                                Text("add contributor")
                            } icon: {
                                Image(systemName: "person")
                            }
            //                .help("Add a new contributor in the task")
                        }
                        
                        Button(action: {editAction(task.id)}) {
                            Label{
                                Text("edit task")
                            } icon: {
                                Image(systemName: "pencil")
                            }
            //                .help("Edit task")
                        }
                        
                        Button(role: .destructive, action: {isDeleting = true}, label: {
                            Label{
                                Text("delete task")
                            } icon: {
                                Image(systemName: "trash")
                            }
            //                .help("Delete task")
                        })
            //            .alert(isPresented: $showingAlert) {
            //                Alert(
            //                    title: Text("Important message"),
            //                    message: Text("Wear sunscreen"),
            //                    dismissButton: .default(Text("Got it!"))
            //                )
            //            }
                    }
                }
        }
        .padding(.leading, leadingWidth)
        //        .frame(height: hourHeight, alignment: .bottom)
        .offset(x: offsetX + CGFloat(position > 1 ? (position - 1) * trailingWidth : 0), y: offsetY + (hourHeight / 2))
        .buttonStyle(NoOpacityAnimationButtonStyle())
        
        .alert(getAlerText(task.name, repeatedTask: repeatedTask()), isPresented: $isDeleting) {
            Button("Delete only this task", role: .destructive) {
                TaskModel.deleteTask(task: task, modelContext: modelContext)
            }
            if repeatedTask() {
                Button("Delete all tasks", role: .destructive) {
                    GroupModel.deleteGroup(group: task.group!, modelContext: modelContext)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .onTapGesture {
            editView = false
            selection = task.id
        }
    }
    
    private func getAlerText(_ name: String, repeatedTask: Bool) -> String {
        if repeatedTask {
            return "Are you sure want to delete \(name)? This is repeating task"
        } else {
            return "Are you sure want to delete \(name)?"
        }
    }
    
    private func editAction(_ id: UUID) -> Void {
        editView = true
        selection = id
    }
    
    private func getPosition() {
        for baseTask in tasks {
            let range = baseTask.start...baseTask.end
            
            var count = 0
            
            for task in tasks {
                if range.contains(task.start) || range.contains(task.end) {
                    count += 1
                }
            }
            positionList.append(count)
        }
        
        let sortPositionList = positionList.enumerated().sorted { $0.1 > $1.1 }
        
        for (index, var item) in sortPositionList.enumerated() {
            var newValue: Int?
            if (sortPositionList.count > index + 1) {
                while item.element > sortPositionList[index + 1].element + 1 {
                    item.element -= 1
                    newValue = item.element
                }
                if (newValue != nil) {
                    positionList[item.offset] = newValue!
                }
            }
        }
        
        let maxElement = positionList.max(by: { a, b in
            
            return a < b
        })
        
        if maxElement != nil && maxElement! > 2 {
            withAnimation(.bouncy) {
                let trailingAmount = ((maxElement! - 1) * trailingWidth) + 50
                hourWidth = ((UIScreen.main.bounds.width - CGFloat(trailingAmount)) / CGFloat(maxElement!))
            }
        }
    }
    
    private func getStartHour() {
        let minElement = tasks.min(by: { a, b in
            let minAValue = getHour(givenDate: a.start)
            let minBValue = getHour(givenDate: b.start)
            
            return minAValue ?? 0 < minBValue ?? 0
        })
        
        let result = getHour(givenDate: minElement?.start)
        
        startHour = result
    }
    
    private func getRange() -> Range<Int> {
        let defaultMin = 0
        let defaultMax = 24
        
        let minElement = tasks.min(by: { a, b in
            let minAValue = getHour(givenDate: a.start)
            let minBValue = getHour(givenDate: b.start)
            
            return minAValue ?? defaultMin < minBValue ?? defaultMin
        })
        let maxElement = tasks.max(by: { a, b in
            let maxAValue = getHour(givenDate: a.end)
            let maxBValue = getHour(givenDate: b.end)
            
            return maxAValue ?? defaultMax < maxBValue ?? defaultMax
        })
        
        let startRange = getHour(givenDate: minElement?.start) ?? defaultMin
        let endRange = getHour(givenDate: maxElement?.end) ?? defaultMax
        
        return startRange ..< (endRange + 1 + 1)
        
    }
    
    private func getHour(givenDate: Date?) -> Int? {
        if givenDate == nil { return nil }
        
        let result = Calendar.current.component(.hour, from: givenDate!)
        
        return result
    }
    
    private func getWidthByContainer(date: Date, index: Int) -> CGFloat {
        let range = date...(Calendar.current.date(byAdding: .hour, value: 1, to: date)!)
        
        var count = 0
        var width = 0
        
        for task in tasks {
            if range.contains(task.start) {
                if (index > tasks.firstIndex(of: task) ?? 0) {
                    count += 1
                    width += Int(hourWidth)
                    //                    width += containerWidthCalc(text: task.name, id: tasks.firstIndex(of: task) ?? 0, sizes: $sizes)
                }
            }
        }
        
        return (count > 0 ? (hourWidth * CGFloat(count)) : 0.0);
    }
    
    private func containerWidthCalc(text: String, id: Int) {
        //        Text(text)
        //            .saveSize(id: id, in: $sizes)
    }
    
    private func offsetYCalculate(start: Int, startMinute: Int) -> CGFloat {
        return (Double(start - (startHour ?? 0)) * hourHeight) + (Double(startMinute) / 60 * hourHeight)
    }
    
}

#Preview {
    TimeLineListView(tasks: TaskModel.samples)
}
