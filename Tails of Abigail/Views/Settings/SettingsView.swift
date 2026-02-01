//
//  SettingsView.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Configuration") {
                    NavigationLink(destination: RoomsSettingsView()) {
                        Label("Rooms", systemImage: "house")
                    }
                    NavigationLink(destination: FurnitureSettingsView()) {
                        Label("Furniture", systemImage: "sofa")
                    }
                }

                Section("About") {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Cat")
                        Spacer()
                        Text("Abby")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
