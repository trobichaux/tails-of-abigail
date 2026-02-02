//
//  FilterState.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import Foundation
import SwiftData

@Observable
final class FilterState {
    var selectedRooms: Set<Room> = []
    var selectedFurniture: Set<Furniture> = []
    var selectedIncidentTypes: Set<IncidentType> = []

    var isAllRoomsSelected: Bool {
        selectedRooms.isEmpty
    }

    var isAllFurnitureSelected: Bool {
        selectedFurniture.isEmpty
    }

    var isAllIncidentTypesSelected: Bool {
        selectedIncidentTypes.isEmpty
    }

    func toggleRoom(_ room: Room) {
        if selectedRooms.contains(room) {
            selectedRooms.remove(room)
        } else {
            selectedRooms.insert(room)
        }
    }

    func toggleFurniture(_ furniture: Furniture) {
        if selectedFurniture.contains(furniture) {
            selectedFurniture.remove(furniture)
        } else {
            selectedFurniture.insert(furniture)
        }
    }

    func clearRoomFilters() {
        selectedRooms.removeAll()
    }

    func clearFurnitureFilters() {
        selectedFurniture.removeAll()
    }

    func toggleIncidentType(_ incidentType: IncidentType) {
        if selectedIncidentTypes.contains(incidentType) {
            selectedIncidentTypes.remove(incidentType)
        } else {
            selectedIncidentTypes.insert(incidentType)
        }
    }

    func clearIncidentTypeFilters() {
        selectedIncidentTypes.removeAll()
    }

    func matchesFilters(_ incident: Incident) -> Bool {
        let roomMatch = selectedRooms.isEmpty || (incident.room != nil && selectedRooms.contains(incident.room!))
        let furnitureMatch = selectedFurniture.isEmpty || (incident.furniture != nil && selectedFurniture.contains(incident.furniture!))
        let incidentTypeMatch = selectedIncidentTypes.isEmpty || selectedIncidentTypes.contains(incident.incidentType)
        return roomMatch && furnitureMatch && incidentTypeMatch
    }
}

extension Array where Element == Incident {
    func filtered(by filterState: FilterState) -> [Incident] {
        self.filter { filterState.matchesFilters($0) }
    }
}
