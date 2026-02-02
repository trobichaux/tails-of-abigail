//
//  IncidentDetailView.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import SwiftUI
import SwiftData

struct IncidentDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Room.sortOrder) private var rooms: [Room]
    @Query(sort: \Furniture.sortOrder) private var furniture: [Furniture]

    @State private var timestamp: Date
    @State private var selectedRoom: Room?
    @State private var selectedFurniture: Furniture?
    @State private var notes: String
    @State private var selectedIncidentType: IncidentType

    let incident: Incident?
    let onSave: (() -> Void)?

    init(incident: Incident? = nil, onSave: (() -> Void)? = nil) {
        self.incident = incident
        self.onSave = onSave
        _timestamp = State(initialValue: incident?.timestamp ?? Date())
        _selectedRoom = State(initialValue: incident?.room)
        _selectedFurniture = State(initialValue: incident?.furniture)
        _notes = State(initialValue: incident?.notes ?? "")
        _selectedIncidentType = State(initialValue: incident?.incidentType ?? .other)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Date & Time") {
                    DatePicker("When", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Type") {
                    Picker("Incident Type", selection: $selectedIncidentType) {
                        ForEach(IncidentType.allCases) { type in
                            Label {
                                Text(type.displayName)
                            } icon: {
                                Image(systemName: type.icon)
                                    .foregroundStyle(type.color)
                            }
                            .tag(type)
                        }
                    }
                }

                Section("Location") {
                    Picker("Room", selection: $selectedRoom) {
                        Text("None").tag(nil as Room?)
                        ForEach(rooms) { room in
                            Text(room.name).tag(room as Room?)
                        }
                    }

                    Picker("Furniture", selection: $selectedFurniture) {
                        Text("None").tag(nil as Furniture?)
                        ForEach(furniture) { item in
                            Text(item.name).tag(item as Furniture?)
                        }
                    }
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(incident == nil ? "New Incident" : "Edit Incident")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveIncident()
                    }
                }
            }
        }
    }

    private func saveIncident() {
        if let incident = incident {
            incident.timestamp = timestamp
            incident.room = selectedRoom
            incident.furniture = selectedFurniture
            incident.notes = notes
            incident.incidentType = selectedIncidentType
        } else {
            let newIncident = Incident(
                timestamp: timestamp,
                furniture: selectedFurniture,
                room: selectedRoom,
                notes: notes,
                incidentType: selectedIncidentType
            )
            modelContext.insert(newIncident)
        }

        onSave?()
        dismiss()
    }
}
