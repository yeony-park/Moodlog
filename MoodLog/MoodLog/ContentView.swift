import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showingRecord = false

    var body: some View {
        VStack(spacing: 16) {
            // Date
            Text(Date(), format: .dateTime.year().month().day())
                .font(.headline)

            // Record
            Button("Log Mood") {
                showingRecord = true
            }
            .buttonStyle(.borderedProminent)

            // Heatmap
            HeatmapView()
                .padding(.horizontal, 50)
        }
        .padding()
        .frame(minWidth: 600)
        .sheet(isPresented: $showingRecord) {
            RecordView()
                .modelContainer(for: MoodLogEntry.self)
        }
    }
}
