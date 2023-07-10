//
//  UserSettingsManager.swift
//  Core Data Dump
//
//  Created by Theo Vora on 7/6/23.
//

import Foundation
import CoreData

class UserSettingsManager {
    var controller: PersistenceController

    private var userSettings: UserSettings
    
    var kitchenSink: [String: Any] {
        guard let dict = userSettings.kitchenSink else {
            return [:]
        }
        return dict
    }
    
    var numbers: [Int] {
        userSettings.numbers ?? []
    }
    
    var uuids: [UUID] {
        userSettings.uuids ?? []
    }
    
    var hasChanges: Bool {
        controller.container.viewContext.hasChanges
    }
    
    init(inMemory: Bool = false) {
        self.controller = inMemory ? PersistenceController.preview : PersistenceController.shared 
        let fetchRequest = UserSettings.fetchRequest()
        
        do {
            let settings = try controller.container.viewContext.fetch(fetchRequest)
            
            if settings.notEmpty,
               let first = settings.first {
                self.userSettings = first
            } else {
                print("🪄 creating settings in Core Data")
                let setting = UserSettings(context: controller.container.viewContext)
                self.userSettings = setting
                save()
            }
            print("#️⃣ numbers =", numbers)
            print("🆔 uuids =", uuids.map { $0.last4 })
        } catch {
            print("😫 wah wah", error)
            print(error.localizedDescription)
            self.userSettings = UserSettings(context: controller.container.viewContext)
            save()
        }
    }
    
    func set(numbers: [Int]) {
        userSettings.numbers = numbers
        save()
    }
    
    func set(uuids: [UUID]) {
        userSettings.uuids = uuids
        save()
    }
    
    func set(kitchenSink: [String: Any]) {
        userSettings.kitchenSink = kitchenSink
        save()
    }
    
    func save() {
        try? controller.container.viewContext.save()
    }
}

extension Collection {
    var notEmpty: Bool {
        !isEmpty
    }
}

extension UUID {
    var last4: String {
        "\(self.uuidString.suffix(4))"
    }
}
