//
//  FilterMenu.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import SwiftUI

struct FilterMenu<T: Identifiable & Hashable>: View where T: AnyObject {
    let title: String
    let items: [T]
    let selectedItems: Set<T>
    let itemName: (T) -> String
    let onToggle: (T) -> Void
    let onClearAll: () -> Void

    var body: some View {
        Menu {
            Button {
                onClearAll()
            } label: {
                Label("All", systemImage: selectedItems.isEmpty ? "checkmark" : "")
            }

            Divider()

            ForEach(items) { item in
                Button {
                    onToggle(item)
                } label: {
                    Label(
                        itemName(item),
                        systemImage: (selectedItems.isEmpty || selectedItems.contains(item)) ? "checkmark" : ""
                    )
                }
            }
        } label: {
            HStack {
                Text(title)
                if !selectedItems.isEmpty {
                    Text("\(selectedItems.count)")
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
        }
    }
}
