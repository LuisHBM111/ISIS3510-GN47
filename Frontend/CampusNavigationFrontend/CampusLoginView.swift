import SwiftUI

struct CampusLoginView: View {
    @EnvironmentObject private var appState: CampusAppState
    @State private var email = "test4@uniandes.edu.co"
    @State private var password = "123456"

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [CampusTheme.background, CampusTheme.primary.opacity(0.45)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    Text("CampusNav")
                        .font(.system(size: 36, weight: .black))
                        .foregroundStyle(CampusTheme.ink)
                    Text("Inicia sesión con tu cuenta de Uniandes para acceder al mapa interactivo.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(CampusTheme.muted)
                }

                VStack(spacing: 16) {
                    CampusInputField(title: "Correo", text: $email, icon: "envelope.fill")
                    CampusInputField(title: "Contraseña", text: $password, icon: "lock.fill", isSecure: true)
                }

                if let message = appState.lastError {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.9), in: RoundedRectangle(cornerRadius: 14))
                }

                Button {
                    Task { await appState.login(email: email, password: password) }
                } label: {
                    HStack(spacing: 10) {
                        if appState.isLoggingIn {
                            ProgressView()
                        }
                        Text(appState.isLoggingIn ? "Ingresando..." : "Ingresar")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundStyle(CampusTheme.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(CampusTheme.primary, in: RoundedRectangle(cornerRadius: 18))
                }
                .disabled(appState.isLoggingIn)

                Button {
                } label: {
                    Text("Crear usuario")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(CampusTheme.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(CampusTheme.primary.opacity(0.5), in: RoundedRectangle(cornerRadius: 18))
                }
                .disabled(true)

                Text("El botón \"Crear usuario\" aún no está conectado porque el backend no expone el endpoint de registro.")
                    .font(.footnote)
                    .foregroundStyle(CampusTheme.muted)

                Spacer()
            }
            .padding(24)
        }
    }
}

#Preview {
    CampusLoginView()
        .environmentObject(CampusAppState())
}
