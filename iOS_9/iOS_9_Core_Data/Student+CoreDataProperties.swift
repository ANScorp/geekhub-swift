//
//  Student+CoreDataProperties.swift
//  iOS_9_Core_Data
//
//  Created by Alex on 12/23/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//
//

import Foundation
import CoreData

extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var name: String?
    @NSManaged public var project: Project?
    @NSManaged public var group: Group?
}
