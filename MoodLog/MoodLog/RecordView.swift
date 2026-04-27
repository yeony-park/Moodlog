import SwiftUI
import SwiftData

struct RecordView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var selectedDate = Date()
    @State private var selectedKeyword: MoodKeyword? = nil
    @State private var selectedIntensity: Int = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Log Mood")
                .font(.title2.bold())

            // Date
            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)

            // Positive keywords
            VStack(alignment: .leading, spacing: 8) {
                Text("Positive")
                    .font(.subheadline.bold())
                    .foregroundStyle(.blue)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 6) {
                    ForEach(MoodKeyword.positive, id: \.self) { keyword in
                        keywordButton(keyword)
                    }
                }
            }

            // Negative keywords
            VStack(alignment: .leading, spacing: 8) {
                Text("Negative")
                    .font(.subheadline.bold())
                    .foregroundStyle(.red)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 6) {
                    ForEach(MoodKeyword.negative, id: \.self) { keyword in
                        keywordButton(keyword)
                    }
                }
            }

            // Intensity (키워드 선택 시에만 표시)
            if selectedKeyword != nil {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Intensity : \(selectedIntensity)")
                        .font(.subheadline.bold())
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { i in
                            Button("\(i)") {
                                selectedIntensity = i
                            }
                            .buttonStyle(.bordered)
                            .tint(selectedIntensity == i ? .blue : .gray)
                        }
                    }
                }
            }

            Spacer()

            // Buttons
            HStack {
                Button("Cancel") { dismiss() }
                    .buttonStyle(.bordered)
                Spacer()
                Button("Save") { save() }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 360, height: 420)
    }

    private func keywordButton(_ keyword: MoodKeyword) -> some View {
        let isSelected = selectedKeyword == keyword
        return Button(keyword.rawValue) {
            if selectedKeyword == keyword {
                selectedKeyword = nil
            } else {
                selectedKeyword = keyword
            }
        }
        .buttonStyle(.bordered)
        .tint(isSelected ? (keyword.isPositive ? .blue : .red) : .gray)
        .font(.system(size: 11))
    }

    private func save() {
        let score: Int
        if let keyword = selectedKeyword {
            score = keyword.isPositive ? selectedIntensity : -selectedIntensity
        } else {
            score = 0
        }
        let entry = MoodLogEntry(
            date: selectedDate,
            keyword: selectedKeyword?.rawValue ?? "",
            score: score
        )
        modelContext.insert(entry)
        dismiss()
    }
}
