import SwiftUI

struct CampusRouteView: View {
    @EnvironmentObject private var appState: CampusAppState
    @State private var origen = "ML 5"
    @State private var destino = "RGD 2"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                inputs
                calculateButton

                if let message = appState.lastError {
                    errorBanner(message)
                }

                if let route = appState.currentRoute {
                    resultCard(route)
                }
            }
            .padding(20)
        }
        .background(CampusTheme.background)
        .navigationTitle("Vista Ruta")
        .navigationBarTitleDisplayMode(.inline)
    }
    private var inputs: some View {
        VStack(spacing: 14) {
            CampusInputField(title: "Origen", text: $origen, icon: "map.circle.fill")
            CampusInputField(title: "Destino", text: $destino, icon: "mappin.circle.fill")
        }
    }
    private var calculateButton: some View {
        Button {
            Task { await appState.calculateRoute(origin: origen, destination: destino) }
        } label: {
            HStack(spacing: 8) {
                if appState.isLoadingRoute { ProgressView() }
                Text(appState.isLoadingRoute ? "Calculando..." : "Calcular ruta")
                    .font(.headline.bold())
            }
            .foregroundStyle(CampusTheme.ink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(CampusTheme.primary, in: RoundedRectangle(cornerRadius: 18))
        }
        .disabled(appState.isLoadingRoute)
    }

    private func resultCard(_ route: RouteResponse) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header: total time
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(route.totalMinutes)")
                    .font(.system(size: 42, weight: .black))
                Text("min")
                    .font(.title3.bold())
                    .foregroundStyle(CampusTheme.muted)
                Spacer()
                Text("\(origen) → \(destino)")
                    .font(.footnote.bold())
                    .foregroundStyle(CampusTheme.muted)
            }

            Divider()
            Text("Pasos")
                .font(.headline)

            if route.path.isEmpty {
                Text("El servidor no devolvió una ruta.")
                    .font(.subheadline)
                    .foregroundStyle(CampusTheme.muted)
            } else {
                ForEach(Array(route.labels.enumerated()), id: \.offset) { index, stop in
                    stepRow(number: index + 1, text: stepText(index: index, stop: stop, total: route.labels.count))
                }
            }
        }
        .padding(18)
        .background(CampusTheme.surface, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(CampusTheme.border, lineWidth: 1))
    }

    private func stepRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.subheadline.bold())
                .frame(width: 28, height: 28)
                .background(CampusTheme.primary, in: Circle())
                .foregroundStyle(CampusTheme.ink)
            Text(text)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func errorBanner(_ message: String) -> some View {
        Text(message)
            .font(.footnote)
            .foregroundStyle(.white)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.red.opacity(0.9), in: RoundedRectangle(cornerRadius: 14))
    }
    private func stepText(index: Int, stop: String, total: Int) -> String {
        if index == 0 { return "Sal desde \(stop)" }
        if index == total - 1 { return "Llega a \(stop)" }
        return "Pasa por \(stop)"
    }
}
#Preview {
    NavigationStack {
        CampusRouteView()
            .environmentObject(CampusAppState())
    }
}
