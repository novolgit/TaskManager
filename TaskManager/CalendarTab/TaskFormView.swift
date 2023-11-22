//
//  TaskFormView..swift
//  manage
//
//  Created by Влад Новолоакэ on 23.09.2023.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct TaskFormView: View {
    enum Field {
        case nameField
        case descriptionField
        
        case recallField
        case reminderField
        case statusField
        case pushTypeField
        
        case selectionFormDateField
        case selectionStartFormDateField
        case selectionFinishFormDateField
        case selectionEndDateField
        
        case customSelectionStartFormDateField
        case customSelectionFinishFormDateField
        
        case selectedDatesField
        case selectedTimesField
        
        case selectedItemsField
        case selectedImagesField
    }
    
    let task: TaskModel?
    
    private var editorTitle: String {
        task == nil ? "Add Task" : "Edit Task"
    }
    
    @FocusState private var focusedField: Field?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    //    @Bindable var task: TaskModel
    
    @State private var name: String = ""
    @State private var description: String = ""
    
    @State private var recall: RecallOption = RecallOption.recallOptions[0]
    @State private var reminder: NotifyReminder = NotifyReminder.notifyReminders[0]
    @State private var status: String = "default"
    @State private var pushType: Bool = false
    
    // MARK: - vars for 'not custom' recall
    @State private var selectionFormDate: Date = Date()
    @State private var selectionStartFormDate: Date = Date()
    @State private var selectionFinishFormDate: Date = Date()  
    @State private var selectionEndDate: Date = Date()
    
    // MARK: - vars for 'custom' recall
    @State private var customSelectionStartFormDate: [Date] = [Date()]
    @State private var customSelectionFinishFormDate: [Date] = [Date()]
    
    @State private var selectedDates: [Int] = []
    @State private var selectedTimes: [Date] = [Date.now]
    
    // MARK: - Image Picker
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    
    // MARK: - loading
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField(
                            "Name *",
                            text: $name,
                            axis: .vertical
                        )
                        .focused($focusedField, equals: .nameField)
                        
                        TextField(
                            "Description",
                            text: $description,
                            axis: .vertical
                        )
                        .focused($focusedField, equals: .descriptionField)
                    }
                    
                    Section {
                        DatePicker(recall.id == 0 ? "Date" : "Start from", selection: $selectionFormDate, displayedComponents: .date)
                            .focused($focusedField, equals: .selectionFormDateField)
                        
                        if recall.id == 5 {
                            DatePicker("End date", selection: $selectionEndDate, displayedComponents: .date)
                        }
                        
                        if recall.id != 5 {
                            if recall.id != 0 {
                                DatePicker("End date", selection: $selectionEndDate, displayedComponents: .date)
                            }
                            Picker("Recall interval", selection: $recall) {
                                ForEach(RecallOption.recallOptions) { option in
                                    Text(option.title.capitalized)
                                        .tag(option as RecallOption)
                                }
                            }
                        }
                        
                        if recall.id != 5 {
                            DatePicker("Starts", selection: $selectionStartFormDate, displayedComponents: .hourAndMinute)
                            
                            DatePicker("Ends", selection: $selectionFinishFormDate, in: selectionStartFormDate..., displayedComponents: .hourAndMinute)
                        }
                    }
                        
                        if recall.id == 5 {
//                            Section {
                                Picker("Recall interval", selection: $recall) {
                                    ForEach(RecallOption.recallOptions) { option in
                                        Text(option.title.capitalized)
                                            .tag(option as RecallOption)
                                        //                                    .onTapGesture {
                                        //                                        recall = option
                                        //                                    }
                                    }
                                }
//
                                // dates picker
                                CustomDatePicker(selectedDates: $selectedDates)
                                
                                // times scheaduler
                                List {
                                    ForEach(Array(selectedTimes.enumerated()), id: \.1) {index, selectedTime in
                                        VStack {
                                            Text("Time №\(index + 1)")
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color("FTextColor"))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            DatePicker("Starts", selection: $customSelectionStartFormDate[index], displayedComponents: .hourAndMinute)
                                            DatePicker("Ends", selection: $customSelectionFinishFormDate[index], displayedComponents: .hourAndMinute)
                                        }
                                    }
                                    .onDelete(perform: selectedTimes.count > 1 ? deleteTime : nil)
                                }
                            
                                    Button(action: {
                                        selectedTimes.append(Date.now)
                                        customSelectionStartFormDate.append(Date.now)
                                        customSelectionFinishFormDate.append(Date.now)
                                        }, label: {
                                            HStack {
                                                Text("Add more time")
                                                Image(systemName: "plus")
                                            }
                                        }
                                    )
                                    .frame(maxWidth: .infinity, alignment: .center)
//                                }
//                            }
                        }
                    
                    Section {
                        Picker("Notify reminder", selection: $reminder) {
                            ForEach(NotifyReminder.notifyReminders) { option in
                                Text(option.title.capitalized)
                                    .tag(option as NotifyReminder)
                            }
                        }
                        
                        Picker("Status", selection: $status) {
                            ForEach(StatusModel.statuses) { option in
                                Text(option.type.capitalized)
                                    .tag(StatusModel.statuses[option.id].type)
                                    .onTapGesture {
                                        status = option.type
                                    }
                            }
                        }
                        
//                        Toggle("Critical", isOn: $pushType)
                    }
                    
                    Section {
                        HStack {
                            LazyVStack {
                                ForEach(0..<selectedImages.count, id: \.self) { i in
                                    selectedImages[i]
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 300)
                                }
                            }
                            
                            Spacer()
                            
                            PhotosPicker(
                                selection: $selectedItems,
                                matching: .images
                            ) {
                                Image(systemName: "paperclip")
                            }
                        }
                        .task(id: selectedItems) {

                            for item in selectedItems {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        let image = Image(uiImage: uiImage)
                                        selectedImages.append(image)
                                    }
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.automatic)
                .disabled(isLoading)
                
                Spacer()
            }
            .modifier(ActivityIndicatorModifier(isLoading: isLoading))
            .navigationBarItems(
                leading: Button(role: .cancel, action: { dismiss()}, label: {
                    Text("Cancel")
                        .multilineTextAlignment(.center)
                }), 
                trailing: Button(action: saveTask, label: {
                    Text("Save")
                        .multilineTextAlignment(.center)
                        .disabled(name.isEmpty)
                })
            )
            .navigationTitle(editorTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let task {
                    name = task.name
                    description = task.descriptionText
                
                    recall = task.recall
                    reminder = task.reminder
                    status = task.status
                    pushType = task.pushType
                
                    selectionFormDate = task.date
                    selectionStartFormDate = task.start
                    selectionFinishFormDate = task.end
//                    selectionEndDate = task.selectionEndDate
                
//                    customSelectionStartFormDate = task.customSelectionStartFormDate
//                    customSelectionFinishFormDate = task.customSelectionFinishFormDate
                
//                    selectedDates = task.selectedDates
//                    selectedTimes = task.selectedTimes
//
//                    selectedItems = task.selectedItems
//                    selectedImages = task.selectedImages
                }
            }
        }
    }
    
    func deleteTime(at offsets: IndexSet) {
        customSelectionStartFormDate.remove(atOffsets: offsets)
        customSelectionFinishFormDate.remove(atOffsets: offsets)
        selectedTimes.remove(atOffsets: offsets)
    }
    
    private func saveTask() {
        debugPrint("creating a task..")
        isLoading = true
        
        if let task {
            editTask()
        } else {
            createTask()
        }
        
        isLoading = false
        
        dismiss()
    }
    
    private func editTask() {
        task!.name = name
        task!.descriptionText = description
    
        task!.recall = recall
        task!.reminder = reminder
        task!.status = status
        task!.pushType = pushType
    
        task!.date = selectionFormDate
        task!.start = selectionStartFormDate
        task!.end = selectionFinishFormDate
    }
    
    private func createTask() {
        // group init
        let group = GroupModel(id: UUID())
        modelContext.insert(group)
        
        let repeatTask: Bool = {
            if recall.id != 0 && recall.id != 5 {
                return true
            }
            return false
        }()
        
        
        let isCustomRecall: Bool = {
            return recall.id == 5
        }()
        
        if isCustomRecall {
            debugPrint("isCustomRecall")
            // MARK: - custom dates
            for (index, _) in selectedTimes.enumerated() {
                let allWeekDays = Date.getAllWeekdays(start: selectionFormDate, end: selectionEndDate, selectedWeekdays: selectedDates, recallId: recall.id)
                for day in allWeekDays {
                    let newTask = TaskModel(
                        
                        date: day,
                        start: customSelectionStartFormDate[index],
                        end: customSelectionFinishFormDate[index],
                        
                        name: name,
                        status: status,
                        pushType: pushType,
                        descriptionText: description,
                        author: UserDefaults.standard.string(forKey: "nickname") ?? "Unknown user",
                        
                        recall: recall,
                        reminder: reminder
                        
                        /// TODO: add contributor integration
                        //            contributors: nil
                        
                        /// TODO: add attachmanets integration
                        //            attachments: selectedImages
                        
                    )
                    
                    modelContext.insert(newTask)
                    if (selectedTimes.count > 0 || allWeekDays.count > 0) {
                        group.tasks?.append(newTask)
                    }
                    
                    createNotification(start: customSelectionStartFormDate[index], custom: true, repeatTask: repeatTask)
                }
            }
        } else {
            
            if repeatTask {
                debugPrint("repeat task")
                // MARK: - every day
                if recall.id == 1 {
                    for day in Date.getAllWeekdays(start: selectionFormDate, end: selectionEndDate, selectedWeekdays: nil, recallId: nil) {
                        let newTask = TaskModel(
                            date: day,
                            start: selectionStartFormDate,
                            end: selectionFinishFormDate,
                            
                            name: name,
                            status: status,
                            pushType: pushType,
                            descriptionText: description,
                            author: UserDefaults.standard.string(forKey: "nickname") ?? "Unknown user",
                            
                            recall: recall,
                            reminder: reminder
                            
                            /// TODO: add contributor integration
                            //            contributors: nil
                            
                        )
                        
                        modelContext.insert(newTask)
                        group.tasks?.append(newTask)
                        
                        createNotification(start: day, custom: false, repeatTask: repeatTask)
                    }
                }
                
                // MARK: - every week
                else if recall.id == 2 {
                    let weekDay: Int = Calendar.current.component(.weekday, from: selectionFormDate)
                    for day in Date.getAllWeekdays(start: selectionFormDate, end: selectionEndDate, selectedWeekdays: [weekDay], recallId: recall.id) {
                        let newTask = TaskModel(
                            date: day,
                            start: selectionStartFormDate,
                            end: selectionFinishFormDate,
                            
                            name: name,
                            status: status,
                            pushType: pushType,
                            descriptionText: description,
                            author: UserDefaults.standard.string(forKey: "nickname") ?? "Unknown user",
                            
                            recall: recall,
                            reminder: reminder
                            
                            /// TODO: add contributor integration
                            //            contributors: nil
                            
                        )
                        
                        modelContext.insert(newTask)
                        group.tasks?.append(newTask)
                        
                        createNotification(start: day, custom: false, repeatTask: repeatTask)
                    }
                }
                
                // MARK: - every month
                else if recall.id == 3 {
                    for day in Date.getAllWeekdays(start: selectionFormDate, end: selectionEndDate, selectedWeekdays: nil, recallId: recall.id) {
                        let newTask = TaskModel(
                            date: day,
                            start: selectionStartFormDate,
                            end: selectionFinishFormDate,
                            
                            name: name,
                            status: status,
                            pushType: pushType,
                            descriptionText: description,
                            author: UserDefaults.standard.string(forKey: "nickname") ?? "Unknown user",
                            
                            recall: recall,
                            reminder: reminder
                            
                            /// TODO: add contributor integration
                            //            contributors: nil
                            
                        )
                        
                        modelContext.insert(newTask)
                        group.tasks?.append(newTask)
                        
                        createNotification(start: day, custom: false, repeatTask: repeatTask)
                    }
                }
                
                // MARK: - every year
                else if recall.id == 4 {
                    for day in Date.getAllWeekdays(start: selectionFormDate, end: selectionEndDate, selectedWeekdays: nil, recallId: recall.id) {
                        let newTask = TaskModel(
                            date: day,
                            start: selectionStartFormDate,
                            end: selectionFinishFormDate,
                            
                            name: name,
                            status: status,
                            pushType: pushType,
                            descriptionText: description,
                            author: UserDefaults.standard.string(forKey: "nickname") ?? "Unknown user",
                            
                            recall: recall,
                            reminder: reminder
                            
                            /// TODO: add contributor integration
                            //            contributors: nil
                            
                        )
                        
                        modelContext.insert(newTask)
                        group.tasks?.append(newTask)
                        
                        createNotification(start: day, custom: false, repeatTask: repeatTask)
                    }
                }
            } else {
                debugPrint("default task")
                let newTask = TaskModel(
                    
                    date: selectionFormDate.toLocalTime(),
                    start: selectionStartFormDate.toLocalTime(),
                    end: selectionFinishFormDate.toLocalTime(),
                    
                    name: name,
                    status: status,
                    pushType: pushType,
                    descriptionText: description,
                    author: UserDefaults.standard.string(forKey: "nickname") ?? "Unknown user",
                    
                    recall: recall,
                    reminder: reminder
                    
                    /// TODO: add contributor integration
                    //            contributors: nil
                    
                )
                
                modelContext.insert(newTask)
                group.tasks?.append(newTask)
                
                createNotification(start: selectionStartFormDate, custom: false, repeatTask: repeatTask)
            }
        }
    }
    
    func createNotification(start: Date, custom: Bool, repeatTask: Bool) {
        let content = UNMutableNotificationContent()
        content.title = "New task by \(UserDefaults.standard.string(forKey: "nickname") ?? "Unknown user")"
        content.subtitle = name
        content.sound = Helper.getNotificationSoundByPushType(givenPushType: pushType)

        let dateForAttention: DateComponents = {
            var dateComponents = DateComponents()
            let calendar = Calendar.current

            let componentDate = calendar.dateComponents([.year, .month, .day], from: selectionFormDate)
            let componentDateTime = calendar.dateComponents([.hour, .minute], from: start)
            
            // MARK: push time set
            if (recall.id == 0 || recall.id == 4) {
                dateComponents.year = componentDate.year
            }
            if (recall.id == 0 || recall.id == 4 || recall.id == 3) {
                dateComponents.month = componentDate.month
            }
            if (recall.id == 0 || recall.id == 4 || recall.id == 3 || recall.id == 2) {
                dateComponents.weekday = componentDate.weekday
                //            dateComponents.weekdayOrdinal = 10
            }
            // custom recall work with only days
            if (recall.id == 0 || recall.id == 4 || recall.id == 3 || recall.id == 2 || recall.id == 1 || recall.id == 5) {
                dateComponents.day = componentDate.day
            }
            
            dateComponents.hour = componentDateTime.hour
            dateComponents.minute = (componentDateTime.minute ?? 0) - (Helper.getRemindTimeByID(reminder.id).minute ?? 0)
            dateComponents.timeZone = .current
            
            return dateComponents
        }()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateForAttention, repeats: repeatTask)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

#Preview {
    TaskFormView(task: TaskModel.samples[0])
}

struct CustomDatePicker: View {
    @Binding var selectedDates: [Int]
    
    let columns = [
        GridItem(.adaptive(minimum: 50))
     ]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
            ForEach(Array(Array.getCustomCalendar().enumerated()), id: \.1) {index, day in
                let isSelected: Bool = {
                    return selectedDates.contains(index)
                }()
                
                Text(day)
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .foregroundColor(isSelected ? Color("Background") : Color("FTextColor"))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(isSelected ? Color("Primary") : Color.clear)
                            .stroke(Color("Primary"), lineWidth: 1)
                    )
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            if isSelected {
                                selectedDates.removeAll { $0 == index }
                            } else {
                                selectedDates.append(index)
                            }
                        }
                    }
            }
        }
    }
}
