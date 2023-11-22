//
//  Board.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 16.11.2023.
//

import Foundation
import SwiftData
import OSLog

private let logger = Logger(subsystem: "BoardData", category: "Board")

@Model
final class Board {
    var id: UUID = UUID()
    var name: String = ""
    
    init(id: UUID = .init(), name: String = "") {
        self.id = id
        self.name = name
    }
}

extension Board {
    static func generateIndividualBoards(modelContext: ModelContext) {
        
        logger.info("Generating individual boards...")
        // Make sure the persistent store is empty. If it's not, return the non-empty container.
        var itemFetchDescriptor = FetchDescriptor<Board>()
        itemFetchDescriptor.fetchLimit = 1
        
        do {
            guard try modelContext.fetchCount(itemFetchDescriptor) == 0 else { return }
        } catch {
            logger.error("Generating individual boards error: \(error.localizedDescription)")
            fatalError("fatal: \(error.localizedDescription)")
        }
        
        // add first board
        modelContext.insert(Board(id: .init(), name: "My Board"))
        logger.info("Completed generating individual boards.")
    }
}
