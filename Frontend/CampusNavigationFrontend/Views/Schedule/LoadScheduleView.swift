import SwiftUI

struct LoadScheduleView: View {
    @Environment(CampusAppState.self) private var appState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Cargar Horario")
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(CampusTheme.ink)

                Text("En esta sección queremos que el usuario cargue el archivo .ics que le da banner. A partir de esto, podemos generar el horario usando las funciones que diseñamos en el back en calendardownload.py")
                    .font(.subheadline)
                    .foregroundStyle(CampusTheme.muted)

                ForEach(CampusMockData.templates) { template in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(template.name)
                                    .font(.headline.bold())
                                Text("Semestre \(template.semester)")
                                    .font(.footnote)
                                    .foregroundStyle(CampusTheme.muted)
                            }

                            Spacer()

                            Button("Cargar") {
                                appState.loadSchedule(template)
                            }
                            .font(.subheadline.bold())
                            .foregroundStyle(CampusTheme.ink)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(CampusTheme.primary, in: Capsule())
                        }

                        ForEach(template.classes) { item in
                            ScheduleRowView(item: item)
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
            .padding(20)
        }
        .background(CampusTheme.background)
        .navigationTitle("Cargar Horario")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LoadScheduleView()
            .environment(CampusAppState())
    }
}
