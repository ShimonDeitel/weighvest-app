import Foundation

struct RuckSession: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var vestWeight: Double
    var distance: Double
    var duration: Double
    var notes: String

    init(id: UUID = UUID(), date: Date = Date(), vestWeight: Double = 0, distance: Double = 0, duration: Double = 0, notes: String = "") {
        self.id = id
        self.date = date
        self.vestWeight = vestWeight
        self.distance = distance
        self.duration = duration
        self.notes = notes
    }
}

struct AppSettings: Codable, Equatable {
    var remindersEnabled: Bool = true
    var metricUnits: Bool = false
    var includeInStreak: Bool = true
}
