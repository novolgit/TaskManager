//
//  Contributor.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 25.10.2023.
//

import Foundation
import SwiftData

enum AvatarImage {
    // The system looks for a file with the specified name in the app's or extension's bundle.
    case imageName(String)
    // Data from an image file or remotely downloaded.
    case imageData(Data)
    // The SF Symbol name.
    case systemImageNamed(String)
}

@Model
final class Contributor {
    var id: UUID = UUID()
    @Attribute(.spotlight) var name: String = ""
//    var tasks: [TaskModel]?
    
    init(id: UUID = .init(), name: String = ""
//         , tasks: [TaskModel]? = []
    ) {
        self.id = id
        self.name = name
//        self.tasks = tasks
    }
}
