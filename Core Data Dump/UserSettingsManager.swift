//
//  UserSettingsManager.swift
//  Core Data Dump
//
//  Created by Theo Vora on 7/6/23.
//

import Foundation
import CoreData

class UserSettingsManager {
    var numbers: [Int]
    var uuids: [UUID]
    var controller: PersistenceController
    
    init(inMemory: Bool = false) {
        self.controller = inMemory ? PersistenceController.preview : PersistenceController.shared 
        let fetchRequest = UserSettings.fetchRequest()
        
        do {
            let settings = try controller.container.viewContext.fetch(fetchRequest)
            
            if settings.notEmpty,
               let first = settings.first {
               
                if let nums = first.numbers {
                    print("😮 retrieved settings from Core Data")
                    print("#️⃣ nums =", nums)
                    self.numbers = nums
                }
                
                if let ids = first.uuids {
                    let prettyIds = ids.map { $0.last4 }
                    print("🆔 uuids =", prettyIds)
                    self.uuids = ids
                } else { // possible this could be nil on first run, since the 1 existing instance will not have this new property. better add it.
                    self.uuids = [UUID()]
                }
                
                print("🎩 now changing it to...")
                var newArr: [Int] = [
                    Int.random(in: (0...9)),
                    Int.random(in: (0...9)),
                    Int.random(in: (0...9))
                ]
                self.numbers = newArr
                
                var newIds = [UUID(), UUID(), UUID()]
                self.uuids = newIds
                
                first.numbers = self.numbers
                first.uuids = self.uuids
                save()
            } else {
                self.numbers = [1, 2, 3]
                self.uuids = [UUID()]
                let setting = UserSettings(context: controller.container.viewContext)
                setting.numbers = self.numbers
                save()
                print("🪄 creating settings in Core Data")
            }
            print("#️⃣ numbers =", numbers)
            print("🆔 uuids =", uuids.map { $0.last4 })
        } catch {
            print("😫 wah wah", error)
            print(error.localizedDescription)
            self.numbers = []
            self.uuids = []
        }
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
