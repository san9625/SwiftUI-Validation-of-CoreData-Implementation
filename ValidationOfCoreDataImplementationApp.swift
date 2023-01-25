//
//  ValidationOfCoreDataImplementationApp.swift
//  ValidationOfCoreDataImplementation
//
//  Created by 吉川創麻 on 2023/01/22.
//

import SwiftUI

@main
struct ValidationOfCoreDataImplementationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
