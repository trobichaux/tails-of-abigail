//
//  StatisticsView.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    @Query private var incidents: [Incident]
    @Query(sort: \Room.sortOrder) private var rooms: [Room]
    @Query(sort: \Furniture.sortOrder) private var furniture: [Furniture]

    @Bindable var filterState: FilterState

    private let calendar = Calendar.current

    var filteredIncidents: [Incident] {
        incidents.filtered(by: filterState)
    }

    var periodData: [(period: String, count: Int)] {
        let now = Date()
        let periods = [
            ("30 days", 30),
            ("60 days", 60),
            ("90 days", 90)
        ]

        return periods.map { period in
            let startDate = calendar.date(byAdding: .day, value: -period.1, to: now)!
            let count = filteredIncidents.filter { $0.timestamp >= startDate }.count
            return (period.0, count)
        }
    }

    var totalIncidents: Int {
        filteredIncidents.count
    }

    var mostFrequentRoom: String? {
        guard filterState.isAllRoomsSelected else { return nil }

        let roomCounts = Dictionary(grouping: filteredIncidents.compactMap { $0.room }, by: { $0.name })
            .mapValues { $0.count }

        return roomCounts.max(by: { $0.value < $1.value })?.key
    }

    var mostFrequentFurniture: String? {
        guard filterState.isAllFurnitureSelected else { return nil }

        let furnitureCounts = Dictionary(grouping: filteredIncidents.compactMap { $0.furniture }, by: { $0.name })
            .mapValues { $0.count }

        return furnitureCounts.max(by: { $0.value < $1.value })?.key
    }

    var averagePerWeek: Double {
        guard !filteredIncidents.isEmpty else { return 0 }

        let sortedIncidents = filteredIncidents.sorted(by: { $0.timestamp < $1.timestamp })
        guard let firstDate = sortedIncidents.first?.timestamp,
              let lastDate = sortedIncidents.last?.timestamp else { return 0 }

        let daysBetween = calendar.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0
        let weeksBetween = Double(max(daysBetween, 7)) / 7.0

        return Double(filteredIncidents.count) / weeksBetween
    }

    var trend: String {
        let thirtyDayCount = periodData.first(where: { $0.period == "30 days" })?.count ?? 0
        let sixtyDayCount = periodData.first(where: { $0.period == "60 days" })?.count ?? 0

        let recentAvg = Double(thirtyDayCount) / 30.0
        let olderAvg = Double(max(sixtyDayCount - thirtyDayCount, 0)) / 30.0

        if recentAvg > olderAvg * 1.1 {
            return "Increasing"
        } else if recentAvg < olderAvg * 0.9 {
            return "Decreasing"
        } else {
            return "Stable"
        }
    }

    var mostCommonIncidentType: String? {
        guard filterState.isAllIncidentTypesSelected else { return nil }

        let typeCounts = Dictionary(grouping: filteredIncidents, by: { $0.incidentType })
            .mapValues { $0.count }

        return typeCounts.max(by: { $0.value < $1.value })?.key.displayName
    }

    var incidentTypeDistribution: [(type: IncidentType, count: Int)] {
        let typeCounts = Dictionary(grouping: filteredIncidents, by: { $0.incidentType })
            .mapValues { $0.count }

        return IncidentType.allCases.compactMap { type in
            if let count = typeCounts[type], count > 0 {
                return (type, count)
            }
            return nil
        }.sorted { $0.count > $1.count }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if filteredIncidents.isEmpty {
                        ContentUnavailableView(
                            "No Data",
                            systemImage: "chart.bar",
                            description: Text(filterState.isAllRoomsSelected && filterState.isAllFurnitureSelected && filterState.isAllIncidentTypesSelected
                                ? "Add incidents to see statistics"
                                : "No incidents match the selected filters")
                        )
                        .frame(minHeight: 400)
                    } else {
                        chartSection
                        if !incidentTypeDistribution.isEmpty {
                            incidentTypeChartSection
                        }
                        summarySection
                    }
                }
                .padding()
            }
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        FilterMenu(
                            title: "Room",
                            items: rooms,
                            selectedItems: filterState.selectedRooms,
                            itemName: { $0.name },
                            onToggle: { filterState.toggleRoom($0) },
                            onClearAll: { filterState.clearRoomFilters() }
                        )

                        FilterMenu(
                            title: "Furniture",
                            items: furniture,
                            selectedItems: filterState.selectedFurniture,
                            itemName: { $0.name },
                            onToggle: { filterState.toggleFurniture($0) },
                            onClearAll: { filterState.clearFurnitureFilters() }
                        )

                        FilterMenu(
                            title: "Type",
                            items: Array(IncidentType.allCases),
                            selectedItems: filterState.selectedIncidentTypes,
                            itemName: { $0.displayName },
                            onToggle: { filterState.toggleIncidentType($0) },
                            onClearAll: { filterState.clearIncidentTypeFilters() }
                        )
                    }
                }
            }
        }
    }

    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Incidents by Period")
                .font(.headline)

            Chart {
                ForEach(periodData, id: \.period) { item in
                    BarMark(
                        x: .value("Period", item.period),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(Color.accentColor)
                    .annotation(position: .top) {
                        Text("\(item.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }

    private var incidentTypeChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Incidents by Type")
                .font(.headline)

            Chart {
                ForEach(incidentTypeDistribution, id: \.type) { item in
                    BarMark(
                        x: .value("Type", item.type.displayName),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(item.type.color)
                    .annotation(position: .top) {
                        Text("\(item.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Summary")
                .font(.headline)

            VStack(spacing: 12) {
                StatRow(label: "Total Incidents", value: "\(totalIncidents)")

                if let room = mostFrequentRoom {
                    StatRow(label: "Most Frequent Room", value: room)
                }

                if let furniture = mostFrequentFurniture {
                    StatRow(label: "Most Frequent Furniture", value: furniture)
                }

                if let type = mostCommonIncidentType {
                    StatRow(label: "Most Common Type", value: type)
                }

                StatRow(label: "Average Per Week", value: String(format: "%.1f", averagePerWeek))

                StatRow(label: "Trend", value: trend)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}
