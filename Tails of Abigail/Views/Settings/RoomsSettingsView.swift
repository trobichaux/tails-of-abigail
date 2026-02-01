//
//  RoomsSettingsView.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import SwiftUI
import SwiftData

struct RoomsSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Room.sortOrder) private var rooms: [Room]
    @State private var editingRoom: Room?
    @State private var newRoomName = ""
    @State private var showingAddSheet = false

    var body: some View {
        List {
            ForEach(rooms) { room in
                HStack {
                    TextField("Room name", text: Binding(
                        get: { room.name },
                        set: { room.name = $0 }
                    ))
                    .textFieldStyle(.plain)
                }
            }
            .onDelete(perform: deleteRooms)
            .onMove(perform: moveRooms)
        }
        .navigationTitle("Rooms")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddSheet = true }) {
                    Label("Add Room", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            NavigationStack {
                Form {
                    TextField("Room Name", text: $newRoomName)
                }
                .navigationTitle("Add Room")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingAddSheet = false
                            newRoomName = ""
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            addRoom()
                        }
                        .disabled(newRoomName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
    }

    private func addRoom() {
        let maxSortOrder = rooms.map(\.sortOrder).max() ?? -1
        let newRoom = Room(name: newRoomName.trimmingCharacters(in: .whitespaces), sortOrder: maxSortOrder + 1)
        modelContext.insert(newRoom)
        newRoomName = ""
        showingAddSheet = false
    }

    private func deleteRooms(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(rooms[index])
        }
    }

    private func moveRooms(from source: IndexSet, to destination: Int) {
        var reorderedRooms = rooms
        reorderedRooms.move(fromOffsets: source, toOffset: destination)
        for (index, room) in reorderedRooms.enumerated() {
            room.sortOrder = index
        }
    }
}
