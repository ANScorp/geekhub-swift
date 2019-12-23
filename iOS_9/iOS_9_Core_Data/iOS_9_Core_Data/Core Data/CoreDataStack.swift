//
//  CoreDataStack.swift
//  iOS_9_Core_Data
//
//  Created by Alex on 12/23/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private init() { }

    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                debugPrint("Unable to load persistent stores: \(error)")
                return
            }
            print(description)
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
        return container
    }()
}
