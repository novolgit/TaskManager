//
//  TaskModel.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 12.10.2023.
//

import Foundation
import SwiftData

@Model
final class TaskModel {
    // rules: Rule(edit: true, remove: false, add: false)
    static var samples = [
        TaskModel(date: Date.now, start: Date.now.addingTimeInterval(60 * 60), end: Date.now.addingTimeInterval(60 * 60 + 360), name: "First task for test", status: "default", pushType: false, descriptionText: "It's my first sample task for test without no a lot of details", author: "Vladislav Novoloake", recall: RecallOption.recallOptions[0], reminder: NotifyReminder.notifyReminders[0]
//             ,contributors: [Contributor(name: "Me")]
            ),
        TaskModel(date: Date.now, start: Date.now.addingTimeInterval(60 * 60 * 60), end: Date.now.addingTimeInterval(60 * 60 * 60 + 360), name: "second", status: "default", pushType: true, descriptionText: "descriptionText2", author: "Me", recall: RecallOption.recallOptions[1], reminder: NotifyReminder.notifyReminders[1]
//             ,contributors: [Contributor( name: "Me")]
            ),
        TaskModel(date: Date.now.addingTimeInterval(100 * 100), start: Date.now.addingTimeInterval(100 * 100 + 60 * 60), end: Date.now.addingTimeInterval(100 * 100 + 60 * 60 + 360), name: "third", status: "default", pushType: false, descriptionText: "descriptionText3", author: "Me", recall: RecallOption.recallOptions[2], reminder: NotifyReminder.notifyReminders[2]
//             ,contributors: [Contributor(name: "me")]
            ),
    ]
    
    var id: UUID = UUID()
    
    var date: Date = Date.now
    var start: Date = Date.now
    var end: Date = Date.now.addingTimeInterval(360)
    
    @Attribute(.spotlight) var name: String = ""
    var status: String = "default"
    var pushType: Bool = false
    var descriptionText: String = ""
    var author: String? = nil
    
    var recall: RecallOption = RecallOption.recallOptions[0]
    var reminder: NotifyReminder = NotifyReminder.notifyReminders[0]
    
    var group: GroupModel? = nil
    
//    var contributors: [Contributor]?
    
    init(
        id: UUID = .init(),
        
        date: Date = Date.now,
        start: Date = Date.now,
        end: Date = Date.now.addingTimeInterval(360),
    
        name: String = "",
        status: String = "",
        pushType: Bool = false,
        descriptionText: String = "",
        author: String = "",
        
        recall: RecallOption = RecallOption.recallOptions[0],
        reminder: NotifyReminder = NotifyReminder.notifyReminders[0]
        
//        contributors: [Contributor]?
    ) {
        self.id = id
        
        self.date = date
        self.start = start
        self.end = end
        
        self.name = name
        self.status = status
        self.pushType = pushType
        self.descriptionText = descriptionText
        self.author = author
        
        self.recall = recall
        self.reminder = reminder
        
//        self.contributors = contributors
    }
    
    static func deleteTask(task: TaskModel, modelContext: ModelContext) -> Void {
        do {
            modelContext.delete(task)
            try modelContext.save()
        } catch {
            debugPrint("delete error: \(error)")
        }
    }
}

/// task struct models
struct PushTypeModel: Identifiable  {
    static let types = ["sound", "critical"/*, "mute"*/]
    
    static var pushTypes = [
        PushTypeModel(id: 0, type: "sound"),
        PushTypeModel(id: 1, type: "critical")
        //        PushTypeModel(id: 2, type: "mute"),
    ]
    
    var id: Int
    var type: String
}

struct StatusModel: Identifiable  {
    static let types = ["default", "importance", "critical", "weak"]
    
    static var statuses = [
        StatusModel(id: 0, type: "default"),
        StatusModel(id: 1, type: "importance"),
        StatusModel(id: 2, type: "critical"),
        StatusModel(id: 3, type: "weak")
    ]
    
    var id: Int
    var type: String
}

//// MARK: - TaskModel Snapshots
//
//extension TaskModel {
//    public func snapshots(through date: Date) -> [TaskModelSnapshot] {
//        var unmergedSnapshots: [TaskModelSnapshot] = []
//
//        // TODO: get all tasks and compare with current time
////        for date in .. {
//            unmergedSnapshots.append(TaskModelSnapshot(
//                task: self,
//                timeInterval: TimeInterval.getTimeRange(task.start, task.end),
//                date: date,
//            ))
////        }
//noti
//        // Initial state.
//        snapshots.insert(TaskModelSnapshot(
//            task: self,
//            timeInterval: TimeInterval.getTimeRange(task.start, task.end),
//            date: .now
//        ), at: 0)
//        
//        return snapshots
//    }
//}
