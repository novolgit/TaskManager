//
//  CalendarTabView.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 04.09.2023.
//

import SwiftUI
import SwiftData

struct CalendarTabView: View {
    @Query private var boards: [Board]
    
    @State private var showingAddForm: Bool = false
    @State private var fullScreen: Bool = false
    
    @State var selectedDate: Date = Date()
    @State var index: Int = 0
    
    @State var currentBoard: UUID = UUID()
    
    //    @State var offset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
//                    BoardsView(currentBoard: $currentBoard)
                    //            Text(selectedDate.formatted(date: .abbreviated, time: .standard))
                    //                .font(.system(size: 28))
                    //                .bold()
                    //                .foregroundColor(Color.accentColor)
                    //                .padding()
                    //                .animation(.spring(), value: selectedDate)
                    //                    VStack {
                    //                        GeometryReader { proxy in
                    CalendarView(currentDate: $selectedDate)
                            .id(index)
                    //                        }
                    //                        .offset(y: -offset)
                    
                    TasksView(sort: SortDescriptor(\TaskModel.date), date: selectedDate)
                }
                //                    .modifier(OffsetModifier(offset: $offset))
                //            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                //                .datePickerStyle(.graphical)
                //                    TodayListView(entries: $entries)
                //                    Spacer()
                
                //                    CalendarComponentView(calendar: Calendar)
                //                    TasksView(date: selectedDate)
                //                    TasksView(sort: SortDescriptor(\TaskModel.dateStart), date: selectedDate)
                //                }
            }
            //            .coordinateSpace(name: "SCROLL")
//            .navigationTitle(getMonth(date: selectedDate)[1])
            .navigationTitle(getCurrentBoard().name)
            .navigationBarTitleDisplayMode(.inline)
            //            .navigationTitle("Calendar")
            .navigationBarItems(trailing:
                                    HStack{
                
                Button {
                    
                } label: {
                    Label("", systemImage: "magnifyingglass")
                        .labelStyle(.iconOnly)
                        .foregroundColor(Color(.link))
                }
                
                Button {
                    addTap()
                } label: {
                    Label("", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .foregroundColor(Color(.link))
                }.sheet(isPresented: $showingAddForm) {
                    TaskFormView(task: nil)
                }
                
                ShareLink(
                    item: "getCurrentBoard(",
                    subject: Text("Cool Photo"),
                    message: Text("Check it out!"),
                    preview: SharePreview(
                        getCurrentBoard().name))
                
            }
                                
            )
            .navigationBarHidden(fullScreen)
        }
//    detail: {
//            Text("Select a task")
//        }
        .statusBar(hidden: fullScreen)
        //            .toolbar {
        //                ToolbarItem(placement: .primaryAction) {
        //                    Button {
        //                        addTap()
        //                    } label: {
        //                        Label("", systemImage: "plus")
        //                            .labelStyle(.iconOnly)
        //                            .foregroundColor(Color(.link))
        //                    }
        //                }
        ////                ToolbarItem(placement: .principal) {
        ////                    Text(getMonth(date: selectedDate)[1])
        ////                }
        //            }
        //            .navigationBarTitleDisplayMode(.inline)
    }
    
    func getCurrentBoard() -> Board {
        return boards.first(where: {board in
            return board.id == currentBoard
        }) ?? boards.first!
    }
    
    func addTap() -> Void {
        showingAddForm.toggle()
    }
    
    func getMonth(date: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: date)
        
        return date.components(separatedBy: " ")
    }
}

#Preview {
    CalendarTabView()
}
