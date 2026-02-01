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

    init(timestamp: Date, furniture: Furniture? = nil, room: Room? = nil, notes: String = "") {
        self.timestamp = timestamp
        self.furniture = furniture
        self.room = room
        self.notes = notes
    }
}
