//
//  DayCell.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import SwiftUI

struct DayCell: View {
    let date: Date
    let incidentCount: Int
    let isToday: Bool

    private let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: date))")
                .font(.body)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundStyle(isToday ? Color.white : Color.primary)

            incidentIndicator
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isToday ? Color.accentColor : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }

    @ViewBuilder
    private var incidentIndicator: some View {
        if incidentCount > 0 {
            HStack(spacing: 2) {
                if incidentCount <= 3 {
                    ForEach(0..<incidentCount, id: \.self) { _ in
                        Circle()
                            .fill(isToday ? Color.white : Color.accentColor)
                            .frame(width: 4, height: 4)
                    }
                } else {
                    Text("\(incidentCount)")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(isToday ? Color.accentColor : Color.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(isToday ? Color.white : Color.accentColor)
                        )
                }
            }
        }
    }
}
