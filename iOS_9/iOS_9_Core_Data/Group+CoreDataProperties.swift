//
//  Group+CoreDataProperties.swift
//  iOS_9_Core_Data
//
//  Created by Alex on 12/23/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//
//

import Foundation
import CoreData

extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var name: String?
    @NSManaged public var students: NSSet?
    @NSManaged public var lectors: NSSet?
}

// MARK: Generated accessors for students
extension Group {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)
}

// MARK: Generated accessors for lectors
extension Group {

    @objc(addLectorsObject:)
    @NSManaged public func addToLectors(_ value: Lector)

    @objc(removeLectorsObject:)
    @NSManaged public func removeFromLectors(_ value: Lector)

    @objc(addLectors:)
    @NSManaged public func addToLectors(_ values: NSSet)

    @objc(removeLectors:)
    @NSManaged public func removeFromLectors(_ values: NSSet)
}
