import Foundation

/// A single performance record capturing how long one user-triggered action took.
struct TimingRecord: Codable, Identifiable {
    let id: UUID
    /// Human-readable label for the action (e.g. "route", "translation", "schedule").
    let action: String
    /// Wall-clock time when the action was initiated.
    let date: Date
    let durationSeconds: Double

    init(action: String, durationSeconds: Double, date: Date = Date()) {
        self.id = UUID()
        self.action = action
        self.date = date
        self.durationSeconds = durationSeconds
    }
}
