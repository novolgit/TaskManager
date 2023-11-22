//
//  EventCardDetailView.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 19.10.2023.
//

import SwiftUI
import SwiftData

struct EventCardDetailView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var currentSegment: Int = 0
    @State private var animate: Bool = false

    var task: TaskModel
    
    @Binding var editMode: Bool
    
    let formatter = DateFormatter()
    
    var segments: Array<String> = ["Overview", "Messages"]
    // TODO: - change to contributors
    var persons: Array<String> = ["person", "person"]
    
    @State var infoList: [InfoViewModel] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            if (editMode) {
                TaskFormView(task: task, editMode: $editMode)
            } else {
                VStack(alignment: .leading) {
                    Text(task.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("STextColor"))
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(Color("STextColor"))
                            .symbolEffect(.bounce.up.byLayer, value: animate)
                            .font(.title3)
                            .fontWeight(.light)
                            .padding(8)
                            .background(
                                Circle()
                                    .stroke(Color("STextColor"), style: StrokeStyle(lineWidth: 1, dash: [1]))
                            )
                            .onAppear {
                                animate = !animate
                            }
                        
                        VStack(alignment: .leading) {
                            Text(getSubtitleFromDate(task.date))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(Color("STextColor"))
                            Text(getTitleText(from: task.start, to: task.end))
                                .font(.subheadline)
                                .foregroundStyle(Color("STextColor"))
                            
                        }
                        
                        Spacer()
                        
                        HStack {
                            ZStack {
//                                if author.avatar != nil {
                                if false {
                                    Image("testPushIcon")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person")
                                        .foregroundStyle(Color("STextColor"))
                                        .symbolEffect(.bounce.up.byLayer, value: animate)
                                        .font(.callout)
                                        .fontWeight(.light)
                                        .padding(8)
                                        .background(
                                            Circle()
                                                .stroke(Color("STextColor"), style: StrokeStyle(lineWidth: 1, dash: [1]))
                                        )
                                        .onAppear {
                                            animate = !animate
                                        }
                                }
                                
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.callout)
                                    .offset(x: -15, y: -15)
                            }
                            Text(task.author ?? "Unknown author")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(Color("STextColor"))
                        }
                    }
                }
                .padding()
                
                // segment tab
                VStack(alignment: .leading) {
                    
                    CustomSegmentedPickerView(currentIndex: Binding<Int>(
                        get: { self.currentSegment},
                        set: { tag in
                            withAnimation {
                                self.currentSegment = tag
                            }
                        }), titles: segments)
                    
                    
//                    Picker("", selection: Binding<Int>(
//                                    get: { self.currentSegment},
//                                    set: { tag in
//                                        withAnimation {
//                                            self.currentSegment = tag
//                                        }
//                                    })) {
//                                    Text(self.segments[0]).tag(0)
//                                    Text(self.segments[1]).tag(1)
//                                }
//                                       .pickerStyle(.segmented)
//                                       .padding(.leading)
//                                       .padding(.trailing)
//                                       .padding(.top)
                    
                    ZStack {
                        Rectangle().fill(Color.clear)
                        if currentSegment == 0 {
                            VStack {
                                ForEach(infoList, id: \.self) { info in
                                    DescriptionInfoContainer(title: info.title, subtitle: info.subtitle, icon: info.icon, type: info.type, persons: info.persons)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color("SecondBackground"))
                            .transition(.move(edge: .leading))
                        }
                        
                        if currentSegment == 1 {
                            VStack {
                                Text("No data")
                                    .frame(maxWidth: .infinity)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color("SecondBackground"))
                            .transition(.move(edge: .trailing))
                        }
                    }
                }
                .background(Color("SecondBackground").edgesIgnoringSafeArea(.all))
                .clipShape(
                    .rect(
                        topLeadingRadius: 20,
                        topTrailingRadius: 20
                    )
                )
                .ignoresSafeArea()
            }
        }
        .background(Color("SecondaryLight"))
        .toolbar {

            
//            if !editMode {
//                Button{
//                    editMode = true
//                } label: {
//                    Label("", systemImage: "pencil.line")
//                }
//            }
            
            if !editMode {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button("Edit") {
                        editMode = true
                    }
                }
            }
            
            if editMode {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button("Cancel") {
                        editMode = false
                    }
                }
            }
            
            if !editMode {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    ShareLink(
                        item: "getCurrentTask",
                        subject: Text("Cool Photo"),
                        message: Text("Check it out!"),
                        preview: SharePreview("Preview"))
                }
            }
        }
        .navigationBarBackButtonHidden(editMode)
        .onAppear {
//            infoList = [
                if task.descriptionText != nil && task.descriptionText != "" {
                    infoList.append(InfoViewModel(title: "Description", subtitle: task.descriptionText, icon: "calendar", type: "String", persons: nil))
                }
                
                   if task.status != nil && task.status != "" {
                       infoList.append(InfoViewModel(title: "Status", subtitle: task.status, icon: "status", type: "String", persons: nil))
                   }
                
                   if task.pushType != nil {
                       infoList.append(InfoViewModel(title: "Push type", subtitle: String(task.pushType), icon: "notification", type: "String", persons: nil))
                   }
                
                   if task.recall != nil && task.recall.title != "" {
                       infoList.append(InfoViewModel(title: "Recall", subtitle: "\(task.recall.title)", icon: "reminder", type: "Int", persons: nil))
                   }
                
                   if task.reminder != nil && task.reminder.title != "" {
                       infoList.append(InfoViewModel(title: "Reminder", subtitle: "\(task.reminder.title)", icon: "reminder", type: "Int", persons: nil))
                   }
                
                   // TODO: add fields
//                   if task.files != nil && task.files != "" {
//                       infoList.append(InfoViewModel(title: "Attachments", subtitle: task.files, icon: "doc.on.doc", type: "File", persons: nil))
//                   }
                
                   // TODO: add fields
//                   if task.contributors != nil && task.contributors != "" {
//                       infoList.append(InfoViewModel(title: "Contributors", subtitle: task.contributors, icon: "person.3", type: "Contributor", persons: persons))
//                   }
//            ]
        }
    }
    
    private func getSubtitleFromDate(_ date: Date) -> String {
//        formatter.dateFormat = "E, d MMM y"
        formatter.dateStyle = .long
        
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        EventCardDetailView(task: TaskModel.samples[0], editMode: .constant(false))
    }
}

struct DescriptionInfoContainer: View {
    let title: String
    let subtitle: String
    let icon: String
    let type: String
    
    let persons: Array<String>?

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(Color("FTextColor"))
            
            if type == "String" {
                Text(subtitle)
                    .font(.callout)
                    .foregroundStyle(Color("FTextColor"))
                
            } else if type == "Int" {
                Text("\(subtitle)")
                    .font(.callout)
                    .foregroundStyle(Color("FTextColor"))
                
            } else if type == "File" {
                Image(systemName: "plus")
                    .font(.callout)
                    .fontWeight(.light)
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .stroke(Color("FTextColor"), style: StrokeStyle(lineWidth: 1, dash: [1]))
                    )
                
            } else if type == "Contributor" {
                HStack {ForEach(Array(persons!.enumerated()), id: \.offset) { offset, item in
                    Image(systemName: item)
                        .font(.title)
                        .fontWeight(.light)
                        .padding(8)
                        .background(
                            Circle()
                                .stroke(Color("FTextColor"), style: StrokeStyle(lineWidth: 1, dash: [1]))
                        )
                    //  .offset(x: index * 5)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct InfoViewModel: Hashable {
    var title: String
    var subtitle: String
    var icon: String
    var type: String
    
    var persons: Array<String>?
}



