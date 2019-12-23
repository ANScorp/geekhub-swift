//
//  Lector+CoreDataProperties.swift
//  iOS_9_Core_Data
//
//  Created by Alex on 12/23/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//
//

import Foundation
import CoreData

extension Lector {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lector> {
        return NSFetchRequest<Lector>(entityName: "Lector")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var name: String?
    @NSManaged public var group: Group?
}
