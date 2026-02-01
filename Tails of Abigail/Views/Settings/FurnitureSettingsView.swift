//
//  FurnitureSettingsView.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import SwiftUI
import SwiftData

struct FurnitureSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Furniture.sortOrder) private var furniture: [Furniture]
    @State private var newFurnitureName = ""
    @State private var showingAddSheet = false

    var body: some View {
        List {
            ForEach(furniture) { item in
                HStack {
                    TextField("Furniture name", text: Binding(
                        get: { item.name },
                        set: { item.name = $0 }
                    ))
                    .textFieldStyle(.plain)
                }
            }
            .onDelete(perform: deleteFurniture)
            .onMove(perform: moveFurniture)
        }
        .navigationTitle("Furniture")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddSheet = true }) {
                    Label("Add Furniture", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            NavigationStack {
                Form {
                    TextField("Furniture Name", text: $newFurnitureName)
                }
                .navigationTitle("Add Furniture")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingAddSheet = false
                            newFurnitureName = ""
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            addFurniture()
                        }
                        .disabled(newFurnitureName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
    }

    private func addFurniture() {
        let maxSortOrder = furniture.map(\.sortOrder).max() ?? -1
        let newFurniture = Furniture(name: newFurnitureName.trimmingCharacters(in: .whitespaces), sortOrder: maxSortOrder + 1)
        modelContext.insert(newFurniture)
        newFurnitureName = ""
        showingAddSheet = false
    }

    private func deleteFurniture(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(furniture[index])
        }
    }

    private func moveFurniture(from source: IndexSet, to destination: Int) {
        var reorderedFurniture = furniture
        reorderedFurniture.move(fromOffsets: source, toOffset: destination)
        for (index, item) in reorderedFurniture.enumerated() {
            item.sortOrder = index
        }
    }
}
