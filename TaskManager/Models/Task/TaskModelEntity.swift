//
//  TaskModelEntity.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 21.11.2023.
//

//import Foundation
//
//struct TaskModelEntity: AppEntity, Identifiable, Hashable {
//    var id: TaskModel.ID
//    var name: String
//    
//    init(id: TaskModel.ID, name: String) {
//        self.id = id
//        self.name = name
//    }
//    
//    init(from task: TaskModel) {
//        self.id = task.id
//        self.name = task.name
//    }
//    
//    var displayRepresentation: DisplayRepresentation {
//        DisplayRepresentation(title: "\(name)")
//    }
//    
//    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Task")
//    static var defaultQuery = TaskModelEntityQuery()
//}
//
//struct TaskModelEntityQuery: EntityQuery, Sendable {
//    func entities(for identifiers: [TaskModelEntity.ID]) async throws -> [TaskModelEntity] {
//        logger.info("Loading tasks for identifiers: \(identifiers)")
//        let modelContext = ModelContext(sharedModelContainer)
//        let tasks = try! modelContext.fetch(FetchDescriptor<TaskModel>(predicate: #Predicate { identifiers.contains($0.id) }))
//        logger.info("Found \(backyards.count) tasks")
//        return tasks.map { TaskModelEntity(from: $0) }
//    }
//    
//    func suggestedEntities() async throws -> [TaskEntity] {
//        logger.info("Loading tasks to suggest for specific task...")
//        let modelContext = ModelContext(sharedModelContainer)
//        let tasks = try! modelContext.fetch(FetchDescriptor<TaskModel>())
//        logger.info("Found \(tasks.count) tasks")
//        return tasks.map { TaskModelEntity(from: $0) }
//    }
//}
