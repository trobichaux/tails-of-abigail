//
//  CalendarView.swift
//  Tails of Abigail
//
//  Created by Claude Code on 2026-02-01.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var incidents: [Incident]
    @Query(sort: \Room.sortOrder) private var rooms: [Room]
    @Query(sort: \Furniture.sortOrder) private var furniture: [Furniture]

    @Bindable var filterState: FilterState

    @State private var displayedMonth = Date()
    @State private var selectedDate: Date?
    @State private var showingIncidentsForDate = false

    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var monthDays: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }

        var days: [Date?] = []
        var currentDate = monthFirstWeek.start

        while days.count < 42 {
            if calendar.isDate(currentDate, equalTo: displayedMonth, toGranularity: .month) {
                days.append(currentDate)
            } else {
                days.append(nil)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return days
    }

    func incidentsForDate(_ date: Date) -> [Incident] {
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        return incidents.filter { incident in
            incident.timestamp >= startOfDay &&
            incident.timestamp < endOfDay &&
            filterState.matchesFilters(incident)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                monthNavigationHeader

                Divider()

                daysOfWeekHeader

                calendarGrid
            }
            .navigationTitle("Calendar")
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
            }
            .sheet(isPresented: $showingIncidentsForDate) {
                if let selectedDate {
                    IncidentListForDateView(
                        date: selectedDate,
                        incidents: incidentsForDate(selectedDate)
                    )
                }
            }
        }
    }

    private var monthNavigationHeader: some View {
        HStack {
            Button {
                changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(displayedMonth, format: .dateTime.month(.wide).year())
                .font(.headline)

            Spacer()

            Button {
                changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }

    private var daysOfWeekHeader: some View {
        HStack(spacing: 0) {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 8)
    }

    private var calendarGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(Array(monthDays.enumerated()), id: \.offset) { _, date in
                if let date {
                    DayCell(
                        date: date,
                        incidentCount: incidentsForDate(date).count,
                        isToday: calendar.isDateInToday(date)
                    )
                    .onTapGesture {
                        selectedDate = date
                        showingIncidentsForDate = true
                    }
                } else {
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        .padding()
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }
}
