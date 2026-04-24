import SwiftUI

struct CreateScheduleView: View {
    @Environment(CampusAppState.self) private var appState
    @State private var draft = ScheduleDraft()

    private let days = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Crear Horario")
                    .font(.system(size: 30, weight: .black))
                    .foregroundStyle(CampusTheme.ink)

                Text("Esta vista permite crear materias manualmente usando información mock.")
                    .font(.subheadline)
                    .foregroundStyle(CampusTheme.muted)

                VStack(spacing: 14) {
                    CampusInputField(title: "Materia", text: $draft.title, icon: "book.fill")
                    CampusInputField(title: "Código", text: $draft.code, icon: "number.square.fill")

                    Picker("Día", selection: $draft.day) {
                        ForEach(days, id: \.self) { day in
                            Text(day).tag(day)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack(spacing: 12) {
                        CampusInputField(title: "Inicio", text: $draft.startTime, icon: "clock.fill")
                        CampusInputField(title: "Fin", text: $draft.endTime, icon: "clock.badge.checkmark.fill")
                    }

                    CampusInputField(title: "Edificio", text: $draft.building, icon: "building.2.fill")
                    CampusInputField(title: "Salón", text: $draft.room, icon: "door.left.hand.open")
                }

                Button {
                    appState.addClass(draft)
                    draft = ScheduleDraft()
                } label: {
                    Text("Guardar clase")
                        .font(.headline.bold())
                        .foregroundStyle(CampusTheme.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(CampusTheme.primary, in: RoundedRectangle(cornerRadius: 18))
                }
                .disabled(!isValid)
                .opacity(isValid ? 1 : 0.55)

                CurrentScheduleListView(
                    title: "Horario actual",
                    subtitle: "Las materias guardadas aquí alimentan el horario activo de la app.",
                    classes: appState.currentSchedule.classes
                )
            }
            .padding(20)
        }
        .background(CampusTheme.background)
        .navigationTitle("Crear Horario")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var isValid: Bool {
        !draft.title.isEmpty &&
        !draft.code.isEmpty &&
        !draft.building.isEmpty &&
        !draft.room.isEmpty
    }
}

#Preview {
    NavigationStack {
        CreateScheduleView()
            .environment(CampusAppState())
    }
}
