import SwiftUI

struct GoalTrackerView: View {
    let title: String
    let value: String
    let valueFont: Font
    let iconSize: CGFloat
    let increment: () -> Void
    let decrement: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            // subtle title
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))

            HStack(spacing: 24) {
                // subtle minus
                Button(action: decrement) {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundColor(.white.opacity(0.2))
                }
                // value with custom font
                Text(value)
                    .font(valueFont)
                    .foregroundColor(.white)
                    .frame(minWidth: 100, alignment: .center)
                // subtle plus
                Button(action: increment) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundColor(.white.opacity(0.2))
                }
            }
        }
    }
}
