//
//  Persistence.swift
//  TILiOS
//
//  Created by Eduard on 28.03.2023.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer()
        
        if inMemory {
            self.container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        self.container.loadPersistentStores { store , error  in
            if let error = error as NSError? {
                fatalError(" \(error.localizedDescription)")
            }
        }
        
    }
    
    var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        return controller
    }()
    
    func sampleData() throws {
        let viewContext = container.viewContext
        
        let user = UserEntity(context: viewContext)
        user.id = UUID()
        user.name = "Eduard"
        user.username = "pen"
        user.acronyms = []

        for i in 1...4 {
            let acronym = AcronymEntity(context: viewContext)
            acronym.short = "short \(i)"
            acronym.long = "long \(i)"
            acronym.user = user
            acronym.categories = []
            acronym.id = UUID()
        }
        
        let category = CategoryEntity(context: viewContext)
        category.name = "Programming"
        category.acronyms = []
        category.id = UUID()
        
        try viewContext.save()
    }
    
}
