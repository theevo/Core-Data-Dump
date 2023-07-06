//
//  ViewModel.swift
//  Core Data Dump
//
//  Created by Theo Vora on 7/6/23.
//

import Foundation
import CoreData

class ViewModel {
    var numbers: [Int]
    var moc: NSManagedObjectContext
    
    init() {
        self.moc = PersistenceController.shared.container.viewContext
        let fetchRequest = UserSettings.fetchRequest()
        
        do {
            let settings = try moc.fetch(fetchRequest)
            
            if settings.notEmpty,
               let first = settings.first,
               let nums = first.numbers {
                print("😮 retrieved settings from Core Data:", nums)
                print("🎩 now changing it to...")
                var newArr: [Int] = [
                    Int.random(in: (0...9)),
                    Int.random(in: (0...9)),
                    Int.random(in: (0...9))
                ]
                self.numbers = newArr
                first.numbers = newArr
                save()
            } else {
                self.numbers = [1, 2, 3]
                let setting = UserSettings(context: moc)
                setting.numbers = self.numbers
                save()
                print("🪄 creating settings in Core Data")
            }
            print("#️⃣ numbers =", numbers)
        } catch {
            print("😫 wah wah", error)
            print(error.localizedDescription)
            self.numbers = []
        }
    }
    
    func save() {
        try? moc.save()
    }
}

extension Collection {
    var notEmpty: Bool {
        !isEmpty
    }
}
