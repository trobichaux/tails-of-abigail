//
//  Tails_of_AbigailApp.swift
//  Tails of Abigail
//
//  Created by Tim Robichaux on 2/1/26.
//

import SwiftUI
import SwiftData

@main
struct Tails_of_AbigailApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Incident.self,
            Room.self,
            Furniture.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            // Seed default data on first launch
            let context = container.mainContext
            let roomDescriptor = FetchDescriptor<Room>()
            let furnitureDescriptor = FetchDescriptor<Furniture>()

            if (try? context.fetchCount(roomDescriptor)) == 0 {
                let defaultRooms = [
                    Room(name: "Living Room", sortOrder: 0),
                    Room(name: "Bedroom", sortOrder: 1),
                    Room(name: "Bathroom", sortOrder: 2),
                    Room(name: "Dining Room", sortOrder: 3),
                    Room(name: "Kitchen", sortOrder: 4),
                    Room(name: "Other", sortOrder: 5)
                ]
                defaultRooms.forEach { context.insert($0) }
            }

            if (try? context.fetchCount(furnitureDescriptor)) == 0 {
                let defaultFurniture = [
                    Furniture(name: "Couch", sortOrder: 0),
                    Furniture(name: "Bed", sortOrder: 1),
                    Furniture(name: "Chair", sortOrder: 2),
                    Furniture(name: "Rug", sortOrder: 3),
                    Furniture(name: "Other", sortOrder: 4)
                ]
                defaultFurniture.forEach { context.insert($0) }
            }

            try? context.save()

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
