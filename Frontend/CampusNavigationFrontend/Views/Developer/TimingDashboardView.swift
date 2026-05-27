import SwiftUI
import Charts

// MARK: - Helper models for chart data

private struct FeatureAvg: Identifiable {
    let id = UUID()
    let action: String
    let avgSeconds: Double
    let count: Int

    var label: String {
        switch action {
        case "route":       return "Ruta"
        case "translation": return "Traducción"
        case "schedule":    return "Horario"
        default:            return action.capitalized
        }
    }

    var color: Color {
        switch action {
        case "route":       return Color(hex: "3B82F6")
        case "translation": return Color(hex: "D4A017")
        case "schedule":    return Color(hex: "10B981")
        default:            return .gray
        }
    }
}

private struct HourPoint: Identifiable {
    let id = UUID()
    let hour: Int
    let action: String
    let avgSeconds: Double

    var actionLabel: String {
        switch action {
        case "route":       return "Ruta"
        case "translation": return "Traducción"
        case "schedule":    return "Horario"
        default:            return action.capitalized
        }
    }
}

// MARK: - Dashboard

struct TimingDashboardView: View {

    private var records: [TimingRecord] { TimingAnalyticsViewModel.shared.records }

    // Average duration per feature
    private var featureAverages: [FeatureAvg] {
        let grouped = Dictionary(grouping: records, by: \.action)
        return grouped.map { action, recs in
            let avg = recs.map(\.durationSeconds).reduce(0, +) / Double(recs.count)
            return FeatureAvg(action: action, avgSeconds: avg, count: recs.count)
        }.sorted { $0.avgSeconds > $1.avgSeconds }
    }

    // Peak hour es la que tiene más registros
    private var peakHour: Int? {
        let counts = Dictionary(grouping: records) { Calendar.current.component(.hour, from: $0.date) }
            .mapValues(\.count)
        return counts.max(by: { $0.value < $1.value })?.key
    }

    // feature más lenta
    private var slowestAtPeak: FeatureAvg? {
        guard let peak = peakHour else { return nil }
        let peakRecords = records.filter {
            Calendar.current.component(.hour, from: $0.date) == peak
        }
        let grouped = Dictionary(grouping: peakRecords, by: \.action)
        return grouped.map { action, recs in
            let avg = recs.map(\.durationSeconds).reduce(0, +) / Double(recs.count)
            return FeatureAvg(action: action, avgSeconds: avg, count: recs.count)
        }.max(by: { $0.avgSeconds < $1.avgSeconds })
    }

    // promedio por feature
    private var hourlyPoints: [HourPoint] {
        let grouped = Dictionary(grouping: records) { record -> String in
            let h = Calendar.current.component(.hour, from: record.date)
            return "\(record.action)|\(h)"
        }
        return grouped.compactMap { key, recs in
            let parts = key.split(separator: "|")
            guard parts.count == 2, let hour = Int(parts[1]) else { return nil }
            let avg = recs.map(\.durationSeconds).reduce(0, +) / Double(recs.count)
            return HourPoint(hour: hour, action: String(parts[0]), avgSeconds: avg)
        }.sorted { $0.hour < $1.hour }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Developer Dashboard")
                        .font(.system(size: 28, weight: .black))
                        .foregroundStyle(CampusTheme.ink)
                    Text("Performance Timing")
                        .font(.subheadline)
                        .foregroundStyle(CampusTheme.muted)
                }

                if records.isEmpty {
                    ContentUnavailableView(
                        "Sin datos aún",
                        systemImage: "chart.bar.xaxis",
                        description: Text("Usa Ruta, Traducción o Horario para generar registros.")
                    )
                    .padding(.top, 60)
                } else {

                    // MARK: Summary cards
                    HStack(spacing: 12) {
                        summaryCard(title: "Registros", value: "\(records.count)")
                        if let peak = peakHour {
                            summaryCard(title: "Peak hour", value: String(format: "%02d:00", peak))
                        }
                        if let slowest = slowestAtPeak {
                            summaryCard(title: "Más lento", value: slowest.label)
                        }
                    }

                    // MARK: Avg por feature
                    chartCard(title: "Tiempo promedio por feature", subtitle: "Todos los registros") {
                        Chart(featureAverages) { item in
                            BarMark(
                                x: .value("Feature", item.label),
                                y: .value("Segundos", item.avgSeconds)
                            )
                            .foregroundStyle(item.color)
                            .cornerRadius(6)
                            .annotation(position: .top) {
                                Text(String(format: "%.2fs", item.avgSeconds))
                                    .font(.caption2.weight(.semibold))
                                    .foregroundStyle(CampusTheme.muted)
                            }
                        }
                        .chartYAxis {
                            AxisMarks(values: .automatic(desiredCount: 4)) { value in
                                AxisGridLine()
                                AxisValueLabel {
                                    if let s = value.as(Double.self) {
                                        Text(String(format: "%.1fs", s)).font(.caption2)
                                    }
                                }
                            }
                        }
                        .frame(height: 200)
                    }


                    // MARK: Respuesta a la pregunta
                    if let slowest = slowestAtPeak, let peak = peakHour {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("¿Cuál feature tiene el mayor tiempo de respuesta durante la hora pico?")
                                .font(.headline)
                                .foregroundStyle(Color(hex: "D4A017"))

                            Text("Durante el peak hour (\(String(format: "%02d:00", peak))), la feature con mayor tiempo de respuesta es ")
                                .font(.subheadline)
                                .foregroundStyle(CampusTheme.ink)
                            + Text("\(slowest.label)")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(CampusTheme.ink)
                            + Text(String(format: " con un promedio de %.2f segundos.", slowest.avgSeconds))
                                .font(.subheadline)
                                .foregroundStyle(CampusTheme.ink)
                        }
                        .padding(16)
                        .background(Color(hex: "FFFBEB"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "FCD34D"), lineWidth: 1))
                    }
                }
            }
            .padding(20)
        }
        .background(CampusTheme.background)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews

    private func summaryCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(CampusTheme.muted)
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(CampusTheme.ink)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(CampusTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(CampusTheme.border, lineWidth: 1))
    }

    private func chartCard<Content: View>(title: String, subtitle: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(CampusTheme.ink)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(CampusTheme.muted)
            }
            content()
        }
        .padding(16)
        .background(CampusTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(CampusTheme.border, lineWidth: 1))
    }
}

#Preview {
    NavigationStack {
        TimingDashboardView()
    }
}
