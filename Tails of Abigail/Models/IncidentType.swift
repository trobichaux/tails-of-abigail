//
//  IncidentType.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-02.
//

import Foundation
import SwiftUI

enum IncidentType: String, Codable, CaseIterable, Hashable, Identifiable {
    case vomit
    case hairball
    case urination
    case defecation
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .vomit:
            return "Vomit"
        case .hairball:
            return "Hairball"
        case .urination:
            return "Urination"
        case .defecation:
            return "Defecation"
        case .other:
            return "Other"
        }
    }

    var icon: String {
        switch self {
        case .vomit:
            return "drop.fill"
        case .hairball:
            return "allergens.fill"
        case .urination:
            return "drop.circle.fill"
        case .defecation:
            return "circle.fill"
        case .other:
            return "questionmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .vomit:
            return .orange
        case .hairball:
            return .brown
        case .urination:
            return .yellow
        case .defecation:
            return .brown
        case .other:
            return .gray
        }
    }
}
