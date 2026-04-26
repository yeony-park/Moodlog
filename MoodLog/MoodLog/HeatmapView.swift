import SwiftUI
import SwiftData

struct HeatmapView: View {
    @Query private var entries: [MoodLogEntry]

    let months = ["Jan","Feb","Mar","Apr","May","Jun",
                  "Jul","Aug","Sep","Oct","Nov","Dec"]
    let cellSize: CGFloat = 14
    let cellSpacing: CGFloat = 2

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Heatmap
            HStack(alignment: .top, spacing: cellSpacing) {
                VStack(alignment: .trailing, spacing: cellSpacing) {
                    Text("").frame(height: cellSize)
                    ForEach(months, id: \.self) { month in
                        Text(month)
                            .font(.system(size: 9))
                            .frame(width: 24, height: cellSize)
                    }
                }

                // day
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: cellSpacing) {
                        HStack(spacing: cellSpacing) {
                            ForEach(1...31, id: \.self) { day in
                                Text("\(day)")
                                    .font(.system(size: 9))
                                    .frame(width: cellSize, height: cellSize)
                                    .multilineTextAlignment(.center)
                            }
                        }

                        // month
                        ForEach(0..<12, id: \.self) { monthIndex in
                            HStack(spacing: cellSpacing) {
                                ForEach(1...31, id: \.self) { day in
                                    cellView(month: monthIndex + 1, day: day)
                                }
                            }
                        }
                    }
                }
            }

            // Legend
            HStack(spacing: 12) {
                Text("Mood :")
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                ForEach(legendItems, id: \.label) { item in
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(item.color)
                            .frame(width: cellSize, height: cellSize)
                        Text(item.label)
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(8)
    }

    private func cellView(month: Int, day: Int) -> some View {
        let entry = entryFor(month: month, day: day)
        let color = colorFor(entry: entry, month: month, day: day)
        return RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: cellSize, height: cellSize)
    }

    private func entryFor(month: Int, day: Int) -> MoodLogEntry? {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        guard let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) else { return nil }
        return entries.first {
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }

    private func colorFor(entry: MoodLogEntry?, month: Int, day: Int) -> Color {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        guard calendar.date(from: DateComponents(year: year, month: month, day: day)) != nil else {
            return Color.clear
        }

        guard let entry else {
            return Color.gray.opacity(0.15)
        }

        switch entry.keyword {
        case _ where entry.keyword.contains("Happy"):    return .blue.opacity(scoreOpacity(entry.score))
        case _ where entry.keyword.contains("Calm"):     return .blue.opacity(scoreOpacity(entry.score) * 0.7)
        case _ where entry.keyword.contains("Neutral"):  return .gray.opacity(scoreOpacity(entry.score))
        case _ where entry.keyword.contains("Tired"):    return .purple.opacity(scoreOpacity(entry.score))
        case _ where entry.keyword.contains("Stressed"): return .pink.opacity(scoreOpacity(entry.score))
        case _ where entry.keyword.contains("Sad"):      return .pink.opacity(scoreOpacity(entry.score) * 1.2)
        default: return .gray.opacity(0.15)
        }
    }

    private func scoreOpacity(_ score: Int) -> Double {
        return Double(score) / 5.0 * 0.85 + 0.15
    }

    var legendItems: [(label: String, color: Color)] {
        [
            ("Happy",    .blue),
            ("Calm",     .blue.opacity(0.6)),
            ("Neutral",  .gray),
            ("Tired",    .purple),
            ("Stressed", .pink),
            ("Sad",      .pink.opacity(0.8)),
        ]
    }
}
