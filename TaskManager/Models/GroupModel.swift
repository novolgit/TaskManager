//
//  Group.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 16.11.2023.
//

import Foundation
import SwiftData

@Model
final class GroupModel {
    var id: UUID = UUID()
    @Relationship(deleteRule: .cascade, inverse: \TaskModel.group) var tasks: [TaskModel]? = []
    
    init(id: UUID = .init()) {
        self.id = id
    }
    
    static func deleteGroup(group: GroupModel, modelContext: ModelContext) -> Void {
        do {
            modelContext.delete(group)
            try modelContext.save()
        } catch {
            debugPrint("delete error: \(error)")
        }
    }
}
