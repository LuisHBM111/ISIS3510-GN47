import SwiftUI

struct CampusHomeView: View {
    @Environment(CampusAppState.self) private var appState
    @State private var path: [CampusDestination] = []
    @State private var showSchedule = false

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    summaryCard

                    Text("Opciones")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(CampusTheme.ink)

                    Button {
                        UsageTracker.shared.record(section: "route")
                        path.append(.route)
                    } label: {
                        HomeActionCard(
                            title: "Planear Ruta",
                            subtitle: "Planea la ruta más eficiente a tu salón",
                            icon: "point.topleft.down.curvedto.point.bottomright.up.fill"
                        )
                    }

                    Button {
                        UsageTracker.shared.record(section: "schedule")
                        path.append(.createSchedule)
                    } label: {
                        HomeActionCard(
                            title: "Crear Horario",
                            subtitle: "Añade las materias que ves este semestre para que te ayudemos a llegar más rápido",
                            icon: "square.and.pencil"
                        )
                    }

                    Button {
                        UsageTracker.shared.record(section: "translator")
                        path.append(.translator)
                    } label: {
                        HomeActionCard(
                            title: "Traductor de Voz",
                            subtitle: "Traductor de voz en tiempo real",
                            icon: "translate"
                        )
                    }

                    Button {
                        UsageTracker.shared.record(section: "map")
                        path.append(.mapView)
                    } label: {
                        HomeActionCard(
                            title: "Mapa",
                            subtitle: "Mapa del campus",
                            icon: "map.fill"
                        )
                    }

                    Button {
                        path.append(.timingDashboard)
                    } label: {
                        HomeActionCard(
                            title: "Developer Dashboard",
                            subtitle: "Tiempos por feature",
                            icon: "chart.bar.xaxis",
                            iconBackgroundColor: Color(hex: "000000"), // Fondo del icono
                            iconColor: Color(hex: "FFEE32") // Color del icono
                        )
                    }
                    

                }
                .padding(20)
            }
            .background(CampusTheme.background)
            .navigationBarHidden(true)
            .navigationDestination(for: CampusDestination.self) { destination in
                switch destination {
                case .route:
                    CampusRouteView()
                case .createSchedule:
                    CreateScheduleView()
                case .loadSchedule:
                    LoadScheduleView()
                case .translator:
                    VoiceTranslatorView()
                case .mapView:
                    CampusMapView()
                case .timingDashboard:
                    TimingDashboardView()
                }
            }
        }
    }

    private var nextClass: ScheduleClass? {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let currentMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)
        let dayOrder: [String: Int] = ["Lunes": 2, "Martes": 3, "Miércoles": 4, "Jueves": 5, "Viernes": 6]

        let sorted = appState.currentSchedule.classes.sorted {
            let aDay = dayOrder[$0.day] ?? 0
            let bDay = dayOrder[$1.day] ?? 0
            return aDay != bDay ? aDay < bDay : $0.startTime < $1.startTime
        }

        return sorted.first { cls in
            guard let clsDay = dayOrder[cls.day] else { return false }
            let parts = cls.startTime.split(separator: ":").compactMap { Int($0) }
            let clsMinutes = parts.count == 2 ? parts[0] * 60 + parts[1] : 0
            if clsDay > weekday { return true }
            if clsDay == weekday { return clsMinutes > currentMinutes }
            return false
        } ?? sorted.first
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Inicio")
                .font(.system(size: 34, weight: .black))
                .foregroundStyle(CampusTheme.ink)
            Text("Hola, \(appState.currentUser?.name ?? "Estudiante")")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(CampusTheme.charcoal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.3)) { showSchedule.toggle() }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(appState.currentSchedule.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(CampusTheme.ink)
                        Text("Semestre \(appState.currentSchedule.semester)")
                            .font(.footnote)
                            .foregroundStyle(CampusTheme.muted)
                    }
                    Spacer()
                    Image(systemName: showSchedule ? "chevron.up" : "chevron.down")
                        .font(.title3)
                        .foregroundStyle(CampusTheme.ink)
                }
            }

            if !showSchedule {
                if let next = nextClass {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Próxima clase")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(CampusTheme.muted)
                        Text("\(next.title) • \(next.day)")
                            .font(.headline)
                        Text("\(next.startTime) - \(next.endTime) • \(next.locationText)")
                            .font(.subheadline)
                            .foregroundStyle(CampusTheme.muted)
                    }
                } else {
                    Text("No hay clases cargadas todavía.")
                        .font(.subheadline)
                        .foregroundStyle(CampusTheme.muted)
                }
            } else {
                if appState.currentSchedule.classes.isEmpty {
                    Text("No hay clases cargadas todavía.")
                        .font(.subheadline)
                        .foregroundStyle(CampusTheme.muted)
                } else {
                    ForEach(appState.currentSchedule.classes) { item in
                        ScheduleRowView(item: item)
                    }
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
}

#Preview {
    CampusHomeView()
        .environment(CampusAppState())
}
