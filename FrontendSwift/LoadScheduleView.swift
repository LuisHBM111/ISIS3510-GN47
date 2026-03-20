import SwiftUI

struct LoadScheduleView: View {
    @EnvironmentObject private var appState: CampusAppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Cargar Horario")
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(CampusTheme.ink)

                Text("Esta vista simula el flujo de cargar un horario existente mientras el backend real se conecta después.")
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
            .environmentObject(CampusAppState())
    }
}
