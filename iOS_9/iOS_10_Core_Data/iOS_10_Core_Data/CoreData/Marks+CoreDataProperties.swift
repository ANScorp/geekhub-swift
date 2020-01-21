//
//  Marks+CoreDataProperties.swift
//  iOS_10_Core_Data
//
//  Created by Alex on 1/20/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//
//

import Foundation
import CoreData


extension Marks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Marks> {
        return NSFetchRequest<Marks>(entityName: "Marks")
    }

    @NSManaged public var clarification: String?
    @NSManaged public var mark: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var homework: Homeworks?
    @NSManaged public var student: Students?

}
