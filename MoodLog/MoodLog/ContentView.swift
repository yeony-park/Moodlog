import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showingRecord = false
    @State private var showingSettings = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // left: Date, right: setting button
            HStack {
                Text(Date(), format: .dateTime.year().month().day())
                    .font(.headline)
                Spacer()
                Button {
                    showingSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            // Heatmap
            HeatmapView()
                .padding(.leading, 20)

            // Bototm : Legend + Log Mood button
            HStack(alignment: .center) {
                Spacer()
                Button("Log Mood") {
                    showingRecord = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .frame(minWidth: 700, minHeight: 400)
        .sheet(isPresented: $showingRecord) {
            RecordView()
        }
    }
}
