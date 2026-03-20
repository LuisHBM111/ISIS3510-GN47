import SwiftUI

struct CampusRootView: View {
    @StateObject private var appState = CampusAppState()

    var body: some View {
        Group {
            if appState.isLoggedIn {
                CampusHomeView()
                    .environmentObject(appState)
            } else {
                CampusLoginView()
                    .environmentObject(appState)
            }
        }
    }
}

#Preview {
    CampusRootView()
}
