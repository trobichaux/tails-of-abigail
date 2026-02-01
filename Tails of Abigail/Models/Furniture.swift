//
//  Furniture.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import Foundation
import SwiftData

@Model
final class Furniture {
    var name: String
    var sortOrder: Int
    @Relationship(deleteRule: .nullify, inverse: \Incident.furniture)
    var incidents: [Incident]?

    init(name: String, sortOrder: Int = 0) {
        self.name = name
        self.sortOrder = sortOrder
    }
}
