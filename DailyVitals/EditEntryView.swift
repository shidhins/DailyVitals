import SwiftUI

struct EditEntryView: View {
    @Binding var entry: DailyEntry
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack(spacing: 30) {
                GoalTrackerView(
                    title: "Calories",
                    value: "\(entry.calories) kcal",
                    valueFont: .system(size: 48, weight: .bold),
                    iconSize: 30,
                    increment: {
                        entry.calories += 50
                    },
                    decrement: {
                        if entry.calories >= 50 {
                            entry.calories -= 50
                        }
                    }
                )

                GoalTrackerView(
                    title: "Water",
                    value: "\(String(format: "%.1f", entry.water)) cups",
                    valueFont: .title2,
                    iconSize: 24,
                    increment: {
                        entry.water += 1.5
                    },
                    decrement: {
                        if entry.water >= 1.5 {
                            entry.water -= 1.5
                        }
                    }
                )

                GoalTrackerView(
                    title: "Sugar",
                    value: "\(String(format: "%.1f", entry.sugar)) tsp",
                    valueFont: .title2,
                    iconSize: 24,
                    increment: {
                        entry.sugar += 0.5
                    },
                    decrement: {
                        if entry.sugar >= 0.5 {
                            entry.sugar -= 0.5
                        }
                    }
                )

                Spacer()

                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle(entry.date)
    }
}
