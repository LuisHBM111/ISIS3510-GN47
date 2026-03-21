import SwiftUI

struct CampusRouteView: View {
    @EnvironmentObject private var appState: CampusAppState
    @State private var origen = "Edifico SD"
    @State private var destino = "ML 203"
    private let travelMinutes = 5


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(spacing: 16) {
                    Text("Elegir origen y destino")
                    CampusInputField(title: "Origen", text: $origen, icon: "map.circle.fill")
                    CampusInputField(title: "Destino", text: $destino, icon: "mappin.circle.fill")
                }

                header
                routeMap
                routeStepsCard
            }
            .padding(20)
        }
        .background(CampusTheme.background)
        .navigationTitle("Vista Ruta")
        .navigationBarTitleDisplayMode(.inline)
    }
    

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ruta sugerida")
                .font(.system(size: 28, weight: .black))
                .foregroundStyle(CampusTheme.ink)

            if let nextClass = appState.currentSchedule.classes.first {
                Text("Desde entrada SD hasta ML 203.")
                    .font(.subheadline)
                    .foregroundStyle(CampusTheme.muted)

                Text("Si sales ahora, llegas a las \(estimatedArrivalText).")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(CampusTheme.charcoal)
            } else {
                Text("Primero debes cargar o crear un horario.")
                    .font(.subheadline)
                    .foregroundStyle(CampusTheme.muted)
            }
        }
    }

    private var routeMap: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [CampusTheme.surface.opacity(0.8), CampusTheme.primary.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 250)

            Path { path in
                path.move(to: CGPoint(x: 50, y: 180))
                path.addLine(to: CGPoint(x: 120, y: 140))
                path.addLine(to: CGPoint(x: 180, y: 150))
                path.addLine(to: CGPoint(x: 260, y: 90))
            }
            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round, dash: [12, 10]))
            .foregroundStyle(CampusTheme.primaryStrong)

            VStack {
                Spacer()
                HStack {
                    badge("\(travelMinutes) min")
                    Spacer()
                    badge("650 m")
                }
            }
            .padding(20)
        }
    }

    private var estimatedArrivalText: String {
        let arrivalDate = Calendar.current.date(byAdding: .minute, value: travelMinutes, to: Date()) ?? Date()
        return arrivalFormatter.string(from: arrivalDate)
    }

    private var arrivalFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }

    private var routeStepsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pasos")
                .font(.title3.bold())
                .foregroundStyle(CampusTheme.ink)

            ForEach(Array(CampusMockData.routeSteps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(index == 0 ? CampusTheme.primary : CampusTheme.surface)
                        .frame(width: 38, height: 38)
                        .overlay(
                            Text("\(index + 1)")
                                .font(.headline.bold())
                                .foregroundStyle(CampusTheme.ink)
                        )

                    Text(step)
                        .font(.body)
                        .foregroundStyle(CampusTheme.charcoal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(18)
        .background(CampusTheme.surface, in: RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(CampusTheme.border, lineWidth: 1)
        )
    }

    private func badge(_ text: String) -> some View {
        Text(text)
            .font(.headline.bold())
            .foregroundStyle(CampusTheme.ink)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.white.opacity(0.92), in: Capsule())
    }
}

#Preview {
    NavigationStack {
        CampusRouteView()
            .environmentObject(CampusAppState())
    }
}
