import Foundation

// MARK: - Report models

struct DashboardReport: Codable {
    let exportedAt: Date
    let summary: ReportSummary
    let timingRecords: [TimingRecord]
    let usageCounts: [String: Int]
}

struct ReportSummary: Codable {
    let totalTimingRecords: Int
    let peakHour: Int?
    let slowestFeatureAtPeak: String?
    let mostVisitedSection: String?
}

// MARK: - Exporter

enum ReportExporter {

    /// Builds the report, writes it to the Documents directory via FileManager,
    /// and returns the file URL so ShareLink can share it.
    static func generateReportURL() throws -> URL {
        let records = TimingAnalyticsViewModel.shared.records
        let counts  = UsageTracker.shared.counts

        let summary = ReportSummary(
            totalTimingRecords: records.count,
            peakHour: peakHour(from: records),
            slowestFeatureAtPeak: slowestFeature(from: records),
            mostVisitedSection: counts.max(by: { $0.value < $1.value })?.key
        )

        let report = DashboardReport(
            exportedAt: Date(),
            summary: summary,
            timingRecords: records,
            usageCounts: counts
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(report)

        // Write to Documents using FileManager
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documents.appendingPathComponent("campus_report.json")
        try data.write(to: fileURL, options: .atomic)

        return fileURL
    }

    // MARK: - Private helpers

    private static func peakHour(from records: [TimingRecord]) -> Int? {
        let counts = Dictionary(grouping: records) {
            Calendar.current.component(.hour, from: $0.date)
        }.mapValues(\.count)
        return counts.max(by: { $0.value < $1.value })?.key
    }

    private static func slowestFeature(from records: [TimingRecord]) -> String? {
        guard let peak = peakHour(from: records) else { return nil }
        let peakRecords = records.filter {
            Calendar.current.component(.hour, from: $0.date) == peak
        }
        let grouped = Dictionary(grouping: peakRecords, by: \.action)
        return grouped.map { action, recs -> (String, Double) in
            let avg = recs.map(\.durationSeconds).reduce(0, +) / Double(recs.count)
            return (action, avg)
        }.max(by: { $0.1 < $1.1 })?.0
    }
}
