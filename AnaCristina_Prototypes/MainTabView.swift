import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
            VoiceTranslatorView()
                .tabItem {
                    Label("Translate", systemImage: "character.book.closed")
                }
        }
    }
}
