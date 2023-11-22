//
//  DataGeneration.swift
//  TaskManager
//
//  Created by Влад Новолоакэ on 21.11.2023.
//

import Observation
import SwiftData
import OSLog

private let logger = Logger(subsystem: "GroupTasksData", category: "DataGeneration")

// MARK: - Data Generation
@Model 
public class DataGeneration {
    public var initializationDate: Date?
    public var lastSimulationDate: Date?
    
    @Transient public var includeEarlyAccessSpecies: Bool = false
    
    public var requiresInitialDataGeneration: Bool {
        initializationDate == nil
    }
    
    public init(initializationDate: Date?, lastSimulationDate: Date?, includeEarlyAccessSpecies: Bool = false) {
        self.initializationDate = initializationDate
        self.lastSimulationDate = lastSimulationDate
        self.includeEarlyAccessSpecies = includeEarlyAccessSpecies
    }
    
    private func simulateHistoricalEvents(modelContext: ModelContext) {
        logger.info("Attempting to simulate historical events...")
        if requiresInitialDataGeneration {
            logger.info("Requires an initial data generation")
            generateInitialData(modelContext: modelContext)
        }
    }
    
    private func generateInitialData(modelContext: ModelContext) {
        logger.info("Generating initial data...")
        
        // Then, generate instances of individual plants not tied to any backyards, all of the birds,
        // and finally the backyards themselves (with their own plants).
        logger.info("Generating initial instances of all boards")
        Board.generateIndividualBoards(modelContext: modelContext)
        // TODO: -
        //        logger.info("Generating initial instances of all tasks")
        //        Task.generateAll(modelContext: modelContext)
        // TODO: -
        //        logger.info("Generating initial instances of groups")
        //        Group.generateAll(modelContext: modelContext)
        
        // TODO: -
        //        logger.info("Generating account")
        //        // The app content is complete, now it's time to create the person's account.
        //        Account.generateAccount(modelContext: modelContext)
        
        logger.info("Completed generating initial data")
        initializationDate = .now
    }
    
    private static func instance(with modelContext: ModelContext) -> DataGeneration {
        if let result = try! modelContext.fetch(FetchDescriptor<DataGeneration>()).first {
            return result
        } else {
            let instance = DataGeneration(
                initializationDate: nil,
                lastSimulationDate: nil
            )
            modelContext.insert(instance)
            return instance
        }
    }
    
    public static func generateAllData(modelContext: ModelContext) {
        let instance = instance(with: modelContext)
        logger.info("Attempting to statically simulate historical events...")
        instance.simulateHistoricalEvents(modelContext: modelContext)
    }
}
