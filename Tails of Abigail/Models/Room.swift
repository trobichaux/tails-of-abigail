//
//  Room.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import Foundation
import SwiftData

@Model
final class Room {
    var name: String
    var sortOrder: Int
    @Relationship(deleteRule: .nullify, inverse: \Incident.room)
    var incidents: [Incident]?

    init(name: String, sortOrder: Int = 0) {
        self.name = name
        self.sortOrder = sortOrder
    }
}
