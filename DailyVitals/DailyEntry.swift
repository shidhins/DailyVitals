import Foundation

struct DailyEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let date: String         // keep as let
    var calories: Int        // make mutable
    var water: Double        // make mutable
    var sugar: Double        // make mutable

    init(id: UUID = UUID(), date: String, calories: Int, water: Double, sugar: Double) {
        self.id = id
        self.date = date
        self.calories = calories
        self.water = water
        self.sugar = sugar
    }
}
