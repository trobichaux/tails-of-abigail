//
//  ContentView.swift
//  Tails of Abigail
//
//  Created by Tim Robichaux on 2/1/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var filterState = FilterState()

    var body: some View {
        TabView {
            CalendarView(filterState: filterState)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            IncidentListView(filterState: filterState)
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }

            StatisticsView(filterState: filterState)
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Incident.self, inMemory: true)
}
