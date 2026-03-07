import SwiftUI

@main
struct MockupsApp: App {
    var body: some Scene {
        WindowGroup {
            FrontSelectorView()
        }
    }
}

private struct FrontSelectorView: View {
    @State private var selected = 0

    var body: some View {
        TabView(selection: $selected) {
            CampusInteractivoView()
                .tag(0)
                .tabItem {
                    Label("Campus", systemImage: "map")
                }

            Mock2RouteGuideView()
                .tag(1)
                .tabItem {
                    Label("Ruta", systemImage: "location")
                }
        }
    }
}
