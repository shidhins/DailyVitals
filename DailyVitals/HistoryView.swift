//
//  HistoryView.swift
//  DailyVitals
//
//  Created by Shidhin Sarath on 4/23/25.
//


import SwiftUI

struct HistoryView: View {
    let entries: [DailyEntry]

    var body: some View {
        List {
          // — Header row —
          Section(header:
            HStack {
              Text("Date")
                .frame(width: 100, alignment: .leading)
              Spacer()
              Text("Cal")
                .frame(width: 60, alignment: .trailing)
              Spacer()
              Text("Water")
                .frame(width: 50, alignment: .trailing)
              Spacer()
              Text("Sugar")
                .frame(width: 50, alignment: .trailing)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.vertical, 4)
          ) {
            // — Data rows —
            ForEach(entries.sorted { $0.date > $1.date }) { entry in
              HStack {
                Text(entry.date)
                  .frame(width: 100, alignment: .leading)
                Spacer()
                Text("\(entry.calories)")
                  .frame(width: 60, alignment: .trailing)
                Spacer()
                Text("\(entry.water)")
                  .frame(width: 50, alignment: .trailing)
                Spacer()
                Text(String(format: "%.1f", entry.sugar))
                  .frame(width: 50, alignment: .trailing)
              }
              .padding(.vertical, 4)
            }
          }
        }
        .listStyle(.plain)
        .navigationTitle("History")

    }
}


