import SwiftUI
import SwiftData

struct RecordView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var selectedDate = Date()
    @State private var selectedKeyword = ""
    @State private var selectedScore = 3

    let keywords = ["😊 Happy", "😌 Calm", "😐 Neutral", "😔 Tired", "😡 Stressed", "😭 Sad"]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Log Mood")
                .font(.title2.bold())

            // 날짜 선택
            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)

            // 감정 키워드
            Text("How are you feeling?")
                .font(.subheadline.bold())

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach(keywords, id: \.self) { keyword in
                    Button(keyword) {
                        selectedKeyword = keyword
                    }
                    .buttonStyle(.bordered)
                    .tint(selectedKeyword == keyword ? .blue : .gray)
                }
            }

            // 점수 선택
            Text("Intensity : \(selectedScore)")
                .font(.subheadline.bold())

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { score in
                    Button("\(score)") {
                        selectedScore = score
                    }
                    .buttonStyle(.bordered)
                    .tint(selectedScore == score ? .blue : .gray)
                }
            }

            Spacer()

            // 저장 버튼
            HStack {
                Button("Cancel") { dismiss() }
                    .buttonStyle(.bordered)
                Spacer()
                Button("Save") {
                    save()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedKeyword.isEmpty)
            }
        }
        .padding()
        .frame(width: 320, height: 380)
    }

    private func save() {
        let entry = MoodLogEntry(
            date: selectedDate,
            keyword: selectedKeyword,
            score: selectedScore
        )
        modelContext.insert(entry)
        dismiss()
    }
}
