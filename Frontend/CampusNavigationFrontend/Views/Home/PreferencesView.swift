import SwiftUI

struct PreferencesView: View {
    @Bindable var prefs: UserPreferences

    var body: some View {
        NavigationStack {
            List {
                Section("Widgets") {
                    Toggle("Clima", isOn: $prefs.showWeather)
                    Toggle("Estadísticas de uso", isOn: $prefs.showStats)
                }
                Section("Opciones visibles") {
                    Toggle("Planear Ruta", isOn: $prefs.showRuta)
                    Toggle("Crear Horario", isOn: $prefs.showHorario)
                    Toggle("Traductor de Voz", isOn: $prefs.showTraductor)
                    Toggle("Mapa", isOn: $prefs.showMapa)
                    Toggle("Mis Tareas", isOn: $prefs.showTareas)
                }
            }
            .navigationTitle("Preferencias")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
