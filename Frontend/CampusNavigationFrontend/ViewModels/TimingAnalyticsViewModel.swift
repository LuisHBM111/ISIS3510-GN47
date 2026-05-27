import Foundation
import Observation
import OSLog

@MainActor
@Observable
final class TimingAnalyticsViewModel {

    static let shared = TimingAnalyticsViewModel()

    var records: [TimingRecord] = []

    private var pendingStarts: [String: Date] = [:]

    private let logger = Logger(subsystem: "com.campusnavigation", category: "timing")

    private init() {
        Task { await load() }
    }


    func load() async {
        let saved = await CampusCache.shared.load([TimingRecord].self, key: CampusCache.timingRecordsKey) ?? []
        records = saved
    }

    
    func record(action: String, start: Date) async {
        let elapsed = Date().timeIntervalSince(start)
        let entry = TimingRecord(action: action, durationSeconds: elapsed)
        records.insert(entry, at: 0)
        await CampusCache.shared.save(records, key: CampusCache.timingRecordsKey)
        logger.info("[\(action)] \(String(format: "%.3f", elapsed))s — total records: \(self.records.count)")
    }

    /// Stores the current time as the start of an in-flight action.
    /// Call this synchronously on the main actor right before triggering the action.
    func beginTiming(for action: String) {
        pendingStarts[action] = Date()
    }

    /// Finalises the timing for an action previously started with `beginTiming(for:)`.
    /// Reads and removes the stored start time, then persists the record.
    func commitTiming(for action: String) async {
        guard let start = pendingStarts.removeValue(forKey: action) else { return }
        await record(action: action, start: start)
    }
}
