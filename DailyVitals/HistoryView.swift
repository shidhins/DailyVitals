import SwiftUI

struct HistoryView: View {
    // Binding to the array of past entries
    @Binding var entries: [DailyEntry]

    // Current-day values to include today's entry
    @AppStorage("calories") private var currCals: Int    = 0
    @AppStorage("water")      private var currWater: Double = 0.0
    @AppStorage("sugar")      private var currSugar: Double = 0.0

    // Navigation and editing state
    @State private var showEdit     = false
    @State private var editingIndex = 0

    // Build a combined list including today's data
    private var allEntries: [DailyEntry] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())

        let todayEntry = DailyEntry(
            date: today,
            calories: currCals,
            water: currWater,
            sugar: currSugar
        )

        var arr = entries
        if !arr.contains(where: { $0.date == todayEntry.date }) {
            arr.append(todayEntry)
        }
        return arr.sorted { $0.date > $1.date }
    }

    var body: some View {
        List {
            // Header
            Section(header:
                HStack {
                    Text("Date").frame(width: 100, alignment: .leading)
                    Spacer()
                    Text("Cal").frame(width: 60, alignment: .trailing)
                    Spacer()
                    Text("Water").frame(width: 50, alignment: .trailing)
                    Spacer()
                    Text("Sugar").frame(width: 50, alignment: .trailing)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.vertical, 4)
            ) {
                // Data rows with tap-to-edit and swipe-to-delete
                ForEach(Array(allEntries.enumerated()), id: \.element.id) { idx, entry in
                    HStack {
                        Text(entry.date)
                            .frame(width: 100, alignment: .leading)
                        Spacer()
                        Text("\(entry.calories)")
                            .frame(width: 60, alignment: .trailing)
                        Spacer()
                        Text(String(format: "%.1f", entry.water))
                            .frame(width: 50, alignment: .trailing)
                        Spacer()
                        Text(String(format: "%.1f", entry.sugar))
                            .frame(width: 50, alignment: .trailing)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // find actual index in binding array
                        if let realIdx = entries.firstIndex(where: { $0.id == entry.id }) {
                            editingIndex = realIdx
                            showEdit = true
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            // confirm and delete
                            entries.removeAll { $0.id == entry.id }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("History")
        // Editing sheet
        .sheet(isPresented: $showEdit) {
            EditEntryView(entry: $entries[editingIndex])
        }
    }
}
