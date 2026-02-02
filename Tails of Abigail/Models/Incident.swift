//
//  Incident.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import Foundation
import SwiftData

@Model
final class Incident {
    var timestamp: Date
    var furniture: Furniture?
    var room: Room?
    var notes: String
    var incidentType: IncidentType

    init(timestamp: Date, furniture: Furniture? = nil, room: Room? = nil, notes: String = "", incidentType: IncidentType = .other) {
        self.timestamp = timestamp
        self.furniture = furniture
        self.room = room
        self.notes = notes
        self.incidentType = incidentType
    }
}
