//
//  Homeworks+CoreDataProperties.swift
//  iOS_10_Core_Data
//
//  Created by Alex on 1/19/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//
//

import Foundation
import CoreData


extension Homeworks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Homeworks> {
        return NSFetchRequest<Homeworks>(entityName: "Homeworks")
    }

    @NSManaged public var task: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var lecture: Lectures?
    @NSManaged public var mark: Marks?

}
