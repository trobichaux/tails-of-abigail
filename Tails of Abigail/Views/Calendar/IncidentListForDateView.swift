//
//  IncidentListForDateView.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import SwiftUI
import SwiftData

struct IncidentListForDateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let date: Date
    let incidents: [Incident]

    @State private var showingAddSheet = false
    @State private var selectedIncident: Incident?

    var body: some View {
        NavigationStack {
            Group {
                if incidents.isEmpty {
                    ContentUnavailableView(
                        "No Recorded Events",
                        systemImage: "calendar",
                        description: Text("Tap the + button to add an incident for this date")
                    )
                } else {
                    List {
                        ForEach(incidents) { incident in
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
            .navigationTitle(date.formatted(date: .long, time: .omitted))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddSheet = true
                    } label: {
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
            modelContext.delete(incidents[index])
        }
    }
}
