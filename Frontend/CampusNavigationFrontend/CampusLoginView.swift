import SwiftUI

struct CampusLoginView: View {
    @EnvironmentObject private var appState: CampusAppState
    @State private var email = "juan@uniandes.edu.co"
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
                    Text("Mockup del ingreso: Diseñamos esto para que se pueda ingresar con cualquier user")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(CampusTheme.muted)
                }

                VStack(spacing: 16) {
                    CampusInputField(title: "Correo", text: $email, icon: "envelope.fill")
                    CampusInputField(title: "Contraseña", text: $password, icon: "lock.fill", isSecure: true)
                }

                Button {
                    appState.login(email: email, password: password)
                } label: {
                    Text("Ingresar")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(CampusTheme.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(CampusTheme.primary, in: RoundedRectangle(cornerRadius: 18))
                }
                Button {
                    
                } label: {
                    Text("Crear usuario")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(CampusTheme.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(CampusTheme.primary, in: RoundedRectangle(cornerRadius: 18))
                }

                Text("Segundo Boton todavía no cumple ninguna función, ya que aún no creamos cuentas de estudiantes.")
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
