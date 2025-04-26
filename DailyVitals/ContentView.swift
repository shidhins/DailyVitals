import SwiftUI
import Foundation

extension Color {
    static let background = Color(red: 0.08, green: 0.08, blue: 0.10)
    static let accent     = Color(red: 0.20, green: 0.60, blue: 0.86)
}

struct ContentView: View {
    @AppStorage("calories") private var calories: Int = 0
    @AppStorage("water")    private var water: Double = 0.0
    @AppStorage("sugar")    private var sugar: Double = 0.0
    @AppStorage("lastOpenedDate") private var lastOpenedDate: String = ""
    @AppStorage("dailyLog") private var dailyLogData: Data = Data()
    @State private var dailyLog: [DailyEntry] = []
    @State private var showHistory = false
    // Stores the last time any button was tapped, formatted "HH:mm"
    @AppStorage("lastUpdateTime") private var lastUpdateTime: String = ""

    // Reusable formatter for hour:minute
    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    @Environment(\.scenePhase) var scenePhase

    init() {
        loadDailyLog()
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    // Title and history link
                    VStack(spacing: 8) {
                        Text("Daily Vitals")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        if !lastUpdateTime.isEmpty {
                            Text("Last updated: \(lastUpdateTime)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.top, 4)
                        }
                    }
                    
                    Spacer()
                    
                    // Calorie counter (just above center)
                    GoalTrackerView(
                        title: "Calories",
                        value: "\(calories)",
                        valueFont: .system(size: 60, weight: .bold),
                        iconSize: 30,
                        increment: {
                            calories += 50
                            lastUpdateTime = ContentView.timeFormatter.string(from: Date())
                        },
                        decrement: {
                            if calories >= 50 {
                                calories -= 50
                                lastUpdateTime = ContentView.timeFormatter.string(from: Date())
                            }
                        }
                    )
                    
                    Spacer()
                    
                    // Water and sugar towards bottom
                    VStack(spacing: 38) {
                        GoalTrackerView(
                            title: "Water",
                            value: "\(water) cups",
                            valueFont: .title2,
                            iconSize: 24,
                            increment: {
                                water += 1.5
                                lastUpdateTime = ContentView.timeFormatter.string(from: Date())
                            },
                            decrement: {
                                if water >= 1.5 {
                                    water -= 1.5
                                    lastUpdateTime = ContentView.timeFormatter.string(from: Date())
                                }
                            }
                        )
                        GoalTrackerView(
                            title: "Sugar",
                            value: "\(String(format: "%.1f", sugar)) tsp",
                            valueFont: .title2,
                            iconSize: 24,
                            increment: {
                                sugar += 0.5
                                lastUpdateTime = ContentView.timeFormatter.string(from: Date())
                            },
                            decrement: {
                                if sugar >= 0.5 {
                                    sugar -= 0.5
                                    lastUpdateTime = ContentView.timeFormatter.string(from: Date())
                                }
                            }
                        )
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 24)
            }
            // Swipe gesture to show history
            .gesture(
                DragGesture(minimumDistance: 50, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width > 50 && abs(value.translation.height) < 30 {
                            showHistory = true
                        }
                    }
            )
            .navigationDestination(isPresented: $showHistory) {
                HistoryView(entries: $dailyLog)
            }
            .onChange(of: scenePhase) { if scenePhase == .active { checkForNewDayAndReset() } }
            .onAppear { loadDailyLog() }
            .onChange(of: dailyLog) {
                if let encoded = try? JSONEncoder().encode(dailyLog) {
                    dailyLogData = encoded
                }
            }
        }
    }

    private func checkForNewDayAndReset() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())

        if today != lastOpenedDate {
            let logDate = lastOpenedDate.isEmpty ? today : lastOpenedDate
            let entry = DailyEntry(date: logDate, calories: calories, water: water, sugar: sugar)
            dailyLog.append(entry)

            if let encoded = try? JSONEncoder().encode(dailyLog) {
                dailyLogData = encoded
            }

            calories = 0
            water = 0
            sugar = 0.0
            lastOpenedDate = today
        }
    }

    private func loadDailyLog() {
        if let log = try? JSONDecoder().decode([DailyEntry].self, from: dailyLogData) {
            dailyLog = log
        }
    }
}

#Preview {
    ContentView()
}
