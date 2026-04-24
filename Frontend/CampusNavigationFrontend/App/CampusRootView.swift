import SwiftUI

struct CampusRootView: View {
    @State private var appState = CampusAppState()

    var body: some View {
        Group {
            if appState.isLoggedIn {
                CampusHomeView()
                    .environment(appState)
            } else {
                CampusLoginView()
                    .environment(appState)
            }
        }
    }
}

#Preview {
    CampusRootView()
}
