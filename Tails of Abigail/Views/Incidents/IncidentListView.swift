//
//  IncidentListView.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import SwiftUI
import SwiftData

struct IncidentListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Incident.timestamp, order: .reverse) private var incidents: [Incident]
    @Query(sort: \Room.sortOrder) private var rooms: [Room]
    @Query(sort: \Furniture.sortOrder) private var furniture: [Furniture]

    @Bindable var filterState: FilterState

    @State private var showingAddSheet = false
    @State private var selectedIncident: Incident?

    var filteredIncidents: [Incident] {
        incidents.filtered(by: filterState)
    }

    var body: some View {
        NavigationStack {
            Group {
                if filteredIncidents.isEmpty {
                    ContentUnavailableView(
                        "No Incidents",
                        systemImage: "checkmark.circle",
                        description: Text(filterState.isAllRoomsSelected && filterState.isAllFurnitureSelected
                            ? "Add your first incident"
                            : "No incidents match the selected filters")
                    )
                } else {
                    List {
                        ForEach(filteredIncidents) { incident in
                            Button {
                                selectedIncident = incident
                            } label: {
                                IncidentRow(incident: incident)
                            }
                            .foregroundStyle(.primary)
                        }
                        .onDelete(perform: deleteIncidents)
                    }
                }
            }
            .navigationTitle("Incidents")
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
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Label("Add Incident", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                IncidentDetailView()
            }
            .sheet(item: $selectedIncident) { incident in
                IncidentDetailView(incident: incident)
            }
        }
    }

    private func deleteIncidents(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredIncidents[index])
        }
    }
}

struct IncidentRow: View {
    let incident: Incident

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(incident.timestamp, style: .date)
                .font(.headline)
            Text(incident.timestamp, style: .time)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                if let room = incident.room {
                    Label(room.name, systemImage: "house")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if let furniture = incident.furniture {
                    Label(furniture.name, systemImage: "sofa")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if !incident.notes.isEmpty {
                Text(incident.notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}
