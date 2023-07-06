//
//  Core_Data_DumpApp.swift
//  Core Data Dump
//
//  Created by Theo Vora on 7/6/23.
//

import SwiftUI

@main
struct Core_Data_DumpApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
