//
//  HistoryViewTab.swift
//  WaterTracker
//
//  Created by Estrella Verdiguel on 13/11/25.
//

import SwiftUI

// MARK: - Main History View
struct HistoryView: View {
    @State private var selectedDate = Date()

    @State private var dailyRecords: [String: [WaterEntry]] = [
        "2025-11-10": [
            WaterEntry(time: "08:30", amount: 250),
            WaterEntry(time: "10:45", amount: 150),
            WaterEntry(time: "13:20", amount: 300),
            WaterEntry(time: "17:00", amount: 250),
            WaterEntry(time: "20:10", amount: 200)
        ],
        "2025-11-11": [
            WaterEntry(time: "09:00", amount: 250),
            WaterEntry(time: "11:30", amount: 250),
            WaterEntry(time: "15:00", amount: 150)
        ],
        "2025-11-12": [
            WaterEntry(time: "07:50", amount: 250),
            WaterEntry(time: "09:30", amount: 250),
            WaterEntry(time: "12:00", amount: 300),
            WaterEntry(time: "18:00", amount: 250)
        ]
    ]

    let goal = 1955

    var body: some View {
        VStack(spacing: 20) {
            Text("Hydration History")
                .font(.title2)
                .bold()
                .padding(.top, 8)

            CalendarGridView(selectedDate: $selectedDate, dailyRecords: convertToTotals(), goal: goal)
                .padding(.bottom, 8)

            RecordListView(records: dailyRecords[formattedKey(for: selectedDate)] ?? [], selectedDate: selectedDate, goal: goal)

            Spacer()
        }
        .padding()
        .navigationTitle("History")
    }

    func convertToTotals() -> [String: Int] {
        var totals: [String: Int] = [:]
        for (date, entries) in dailyRecords {
            totals[date] = entries.reduce(0) { $0 + $1.amount }
        }
        return totals
    }

    func formattedKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct WaterEntry: Identifiable {
    let id = UUID()
    let time: String
    let amount: Int
}

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    var dailyRecords: [String: Int]
    var goal: Int

    private let calendar = Calendar.current

    private var monthDays: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: selectedDate) else { return [] }
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }

    private var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: selectedDate).capitalized
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }

                Spacer()
                Text(monthName)
                    .font(.headline)
                Spacer()

                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal, 4)

            let days = ["S","M","T","W","T","F","S"]
            HStack {
                ForEach(days, id: \.self) { d in
                    Text(d)
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(monthDays, id: \.self) { date in
                    let key = formattedKey(for: date)
                    let total = dailyRecords[key] ?? 0
                    let progress = CGFloat(total) / CGFloat(goal)

                    VStack(spacing: 6) {
                        Circle()
                            .fill(colorForProgress(progress))
                            .frame(width: 34, height: 34)
                            .overlay(
                                Text("\(calendar.component(.day, from: date))")
                                    .font(.caption2)
                                    .foregroundColor(progress > 0.5 ? .white : .black)
                            )
                            .onTapGesture {
                                selectedDate = date
                            }

                        if Calendar.current.isDate(date, inSameDayAs: selectedDate) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 5, height: 5)
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 5, height: 5)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    func formattedKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }

    func colorForProgress(_ progress: CGFloat) -> Color {
        switch progress {
        case 1.0...: return .blue
        case 0.5..<1.0: return Color.blue.opacity(0.45)
        case 0.1..<0.5: return Color.gray.opacity(0.3)
        default: return Color.gray.opacity(0.12)
        }
    }
}

struct RecordListView: View {
    var records: [WaterEntry]
    var selectedDate: Date
    var goal: Int

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(formattedDate)
                .font(.headline)

            if records.isEmpty {
                Text("No records for this day")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(records) { record in
                            HStack {
                                HStack(spacing: 8) {
                                    Image(systemName: "clock")
                                    Text(record.time)
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text("\(record.amount) ml")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.blue)
                            }
                            .padding(10)
                            .background(Color.blue.opacity(0.04))
                            .cornerRadius(10)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
        }
    }
}

#Preview {
    HistoryView()
}

