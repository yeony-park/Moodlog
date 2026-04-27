import Foundation
import SwiftData

enum MoodKeyword: String, Codable, CaseIterable {
    // Positive
    case joyful = "Joyful"
    case peaceful = "Peaceful"
    case excited = "Excited"
    case cozy = "Cozy"
    case confident = "Confident"
    case grateful = "Grateful"
    case motivated = "Motivated"
    case content = "Content"
    case calm = "Calm"
    case refreshed = "Refreshed"
    
    // Negative
    case gloomy = "Gloomy"
    case lonely = "Lonely"
    case tired = "Tired"
    case anxious = "Anxious"
    case frustrated = "Frustrated"
    case overwhelmed = "Overwhelmed"
    case sad = "Sad"
    case irritated = "Irritated"
    case empty = "Empty"
    case burnedOut = "Burned Out"
    
    var isPositive: Bool {
        switch self {
        case .joyful, .peaceful, .excited, .cozy, .confident, .grateful, .motivated, .content, .calm, .refreshed:
            return true
        default:
            return false
        }
    }
    
    static var positive: [MoodKeyword] {
        allCases.filter { $0.isPositive }
    }
    
    static var negative: [MoodKeyword] {
        allCases.filter { !$0.isPositive }
    }
}

@Model
final class MoodLogEntry {
    var id: UUID
    var date: Date
    var keyword: String?
    var score: Int // -5 ~ +5, 0 = no feeling
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
    var positiveColor: String
    var negativeColor: String
    var scoreMode: Int
    
    init(language: String = "en", positiveColor: String = "blue", negativeColor: String = "red", scoreMode: Int = 5) {
        self.id = UUID()
        self.language = language
        self.positiveColor = positiveColor
        self.negativeColor = negativeColor
        self.scoreMode = scoreMode
    }
}
