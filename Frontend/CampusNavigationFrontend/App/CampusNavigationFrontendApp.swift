//
//  CampusNavigationFrontendApp.swift
//  CampusNavigationFrontend
//
//  Created by Juan Ernesto Pinto on 20/03/26.
//

import SwiftUI
import SwiftData

@main
struct CampusNavigationFrontendApp: App {
    var body: some Scene {
        WindowGroup {
            CampusRootView()
        }
        .modelContainer(for: ToDoItem.self)
    }
}

