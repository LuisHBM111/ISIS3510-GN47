import SwiftUI

struct CampusLoginView: View {
    @Environment(CampusAppState.self) private var appState
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false

    var body: some View {
        @Bindable var appState = appState
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
                    Text(isSignUp ? "Crea tu cuenta institucional" : "Ingresa con tu correo institucional")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(CampusTheme.muted)
                }

                VStack(spacing: 16) {
                    CampusInputField(title: "Correo", text: $email, icon: "envelope.fill")
                    CampusInputField(title: "Contraseña", text: $password, icon: "lock.fill", isSecure: true)
                }.foregroundStyle(CampusTheme.ink)
                    .foregroundStyle(CampusTheme.muted)

                if let err = appState.loginError {
                    Text(err)
                        .font(.footnote.bold())
                        .foregroundStyle(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.85), in: RoundedRectangle(cornerRadius: 12))
                }

                Button {
                    Task {
                        if isSignUp {
                            await appState.signUp(email: email, password: password)
                        } else {
                            await appState.login(email: email, password: password)
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        if appState.isAuthenticating { ProgressView() }
                        Text(appState.isAuthenticating ? "Procesando..." : (isSignUp ? "Crear cuenta" : "Ingresar"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(CampusTheme.ink)
                    }
                    .foregroundStyle(CampusTheme.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(CampusTheme.primary, in: RoundedRectangle(cornerRadius: 18))
                }
                .disabled(appState.isAuthenticating)

                Button {
                    isSignUp.toggle()
                    appState.loginError = nil
                } label: {
                    Text(isSignUp ? "¿Ya tienes cuenta? Inicia sesión" : "¿No tienes cuenta? Regístrate")
                        .font(.footnote.bold())
                        .foregroundStyle(CampusTheme.charcoal)
                        .frame(maxWidth: .infinity)
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

#Preview {
    CampusLoginView()
        .environment(CampusAppState())
}
