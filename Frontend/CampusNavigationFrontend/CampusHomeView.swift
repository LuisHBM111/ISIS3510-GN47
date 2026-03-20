import SwiftUI

struct CampusHomeView: View {
    @EnvironmentObject private var appState: CampusAppState
    @State private var path: [CampusDestination] = []

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
                        path.append(.route)
                    } label: {
                        HomeActionCard(
                            title: "Planear Ruta",
                            subtitle: "Planea la ruta más eficiente a tu salón",
                            icon: "point.topleft.down.curvedto.point.bottomright.up.fill"
                        )
                    }

                    Button {
                        path.append(.createSchedule)
                    } label: {
                        HomeActionCard(
                            title: "Crear Horario",
                            subtitle: "Añade las materias que ves este semestre para que te ayudemos a llegar más rápido",
                            icon: "square.and.pencil"
                        )
                    }

                    Button {
                        path.append(.loadSchedule)
                    } label: {
                        HomeActionCard(
                            title: "Cargar Horario",
                            subtitle: "Carga tu archivo .ics",
                            icon: "tray.and.arrow.down.fill"
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
                }
            }
        }
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
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appState.currentSchedule.name)
                        .font(.system(size: 20, weight: .bold))
                    Text("Semestre \(appState.currentSchedule.semester)")
                        .font(.footnote)
                        .foregroundStyle(CampusTheme.muted)
                }
                Spacer()
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundStyle(CampusTheme.ink)
            }

            if let nextClass = appState.currentSchedule.classes.first {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Próxima clase")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(CampusTheme.muted)
                    Text("\(nextClass.title) • \(nextClass.day)")
                        .font(.headline)
                    Text("\(nextClass.startTime) - \(nextClass.endTime) • \(nextClass.locationText)")
                        .font(.subheadline)
                        .foregroundStyle(CampusTheme.muted)
                }
            } else {
                Text("No hay clases cargadas todavía.")
                    .font(.subheadline)
                    .foregroundStyle(CampusTheme.muted)
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
        .environmentObject(CampusAppState())
}
