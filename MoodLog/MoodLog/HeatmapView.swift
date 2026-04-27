import SwiftUI
import SwiftData

private let positiveColors: [Color] = [
    Color(hex: "D2E5ED"),  // score +1
    Color(hex: "B8D8E8"),  // score +2
    Color(hex: "83C6DF"),  // score +3
    Color(hex: "5AAED6"),  // score +4
    Color(hex: "3283CE"),  // score +5
]

private let negativeColors: [Color] = [
    Color(hex: "FFEFEC"),  // score -1
    Color(hex: "FFD6CE"),  // score -2
    Color(hex: "FFB9AE"),  // score -3
    Color(hex: "F89A8A"),  // score -4
    Color(hex: "F07F6E"),  // score -5
]

struct HeatmapView: View {
    @Query private var entries: [MoodLogEntry]

    let months = ["Jan","Feb","Mar","Apr","May","Jun",
                  "Jul","Aug","Sep","Oct","Nov","Dec"]
    let cellSize: CGFloat = 16
    let cellSpacing: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 4) {
                // month label
                VStack(alignment: .trailing, spacing: cellSpacing) {
                    Text("").frame(height: cellSize)
                    ForEach(months, id: \.self) { month in
                        Text(month)
                            .font(.system(size: 10))
                            .frame(width: 28, height: cellSize)
                    }
                }

                // Day headers + cells
                VStack(alignment: .leading, spacing: cellSpacing) {
                    // Monthly rows
                    HStack(spacing: cellSpacing) {
                        ForEach(1...31, id: \.self) { day in
                            Text("\(day)")
                                .font(.system(size: 9))
                                .frame(width: cellSize, height: cellSize)
                                .multilineTextAlignment(.center)
                        }
                    }

                    // Monthly rows
                    ForEach(0..<12, id: \.self) { monthIndex in
                        HStack(spacing: cellSpacing) {
                            ForEach(1...31, id: \.self) { day in
                                cellView(month: monthIndex + 1, day: day)
                            }
                        }
                    }
                }
            }

            // Legend
            // Legend
            HStack(spacing: 16) {
                Text("Positive")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                HStack(spacing: 3) {
                    ForEach((0..<5).reversed(), id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(positiveColors[i])
                            .frame(width: 12, height: 12)
                    }
                }

                Spacer()
                    .frame(width: 8)

                HStack(spacing: 3) {
                    ForEach(0..<5, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(negativeColors[i])
                            .frame(width: 12, height: 12)
                    }
                }
                Text("Negative")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(8)
    }

    private func cellView(month: Int, day: Int) -> some View {
        let color = colorFor(month: month, day: day)
        return RoundedRectangle(cornerRadius: 3)
            .fill(color)
            .frame(width: cellSize, height: cellSize)
    }

    private func colorFor(month: Int, day: Int) -> Color {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        guard calendar.date(from: DateComponents(year: year, month: month, day: day)) != nil else {
            return Color.clear
        }
        guard let entry = entryFor(month: month, day: day) else {
            return Color.gray.opacity(0.15)
        }

        let score = entry.score
        if score == 0 { return Color.white }

        let index = abs(score) - 1  // 1~5 → 0~4
        if score > 0 {
            return positiveColors[index]
        } else {
            return negativeColors[index]
        }
    }

    private func entryFor(month: Int, day: Int) -> MoodLogEntry? {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        guard let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) else { return nil }
        return entries.first { calendar.isDate($0.date, inSameDayAs: date) }
    }

    private func scoreOpacity(_ score: Int) -> Double {
        return Double(score) / 5.0 * 0.85 + 0.15
    }

    var legendItems: [(label: String, color: Color)] {
        [
            ("Positive ×1", positiveColors[0]),
            ("Positive ×3", positiveColors[2]),
            ("Positive ×5", positiveColors[4]),
            ("Negative ×1", negativeColors[0]),
            ("Negative ×3", negativeColors[2]),
            ("Negative ×5", negativeColors[4]),
        ]
    }
}
