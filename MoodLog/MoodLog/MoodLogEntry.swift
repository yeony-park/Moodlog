import Foundation
import SwiftData

@Model
final class MoodLogEntry {
    var id: UUID
    var date: Date
    var keyword: String
    var score: Int
    var memo: String?
    var createdAt: Date
    var updatedAt: Date
    
    init(date: Date, keyword: String, score: Int, memo: String? = nil) {
        self.id = UUID()
        self.date = date
        self.keyword = keyword
        self.score = score
        self.memo = memo
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

@Model
final class YearSummary {
    var id: UUID
    var year: Int
    var message: String
    var createdAt: Date
    
    init(year: Int, message: String) {
        self.id = UUID()
        self.year = year
        self.message = message
        self.createdAt = Date()
    }
}

@Model
final class AppSettings {
    var id: UUID
    var language: String
    var themeColor: String
    var scoreMode: Int
    
    init(language: String = "ko", themeColor: String="purple", scoreMode: Int = 5) {
        self.id = UUID()
        self.language = language
        self.themeColor = themeColor
        self.scoreMode = scoreMode
    }
}
