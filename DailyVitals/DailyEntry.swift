//
//  DailyEntry.swift
//  DailyVitals
//
//  Created by Shidhin Sarath on 4/23/25.
//


import Foundation

struct DailyEntry: Codable, Identifiable {
    let id: UUID
    let date: String // formatted as "yyyy-MM-dd"
    let calories: Int
    let water: Int
    let sugar: Double
    
    // Custom initializer enables decoding 'id' and provides a default for new entries
        init(id: UUID = UUID(), date: String, calories: Int, water: Int, sugar: Double) {
            self.id = id
            self.date = date
            self.calories = calories
            self.water = water
            self.sugar = sugar
        }
}
