//
//  Students+CoreDataProperties.swift
//  iOS_10_Core_Data
//
//  Created by Alex on 1/13/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//
//

import Foundation
import CoreData


extension Students {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Students> {
        return NSFetchRequest<Students>(entityName: "Students")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var date: Date?
    @NSManaged public var marks: NSSet?

}

// MARK: Generated accessors for marks
extension Students {

    @objc(addMarksObject:)
    @NSManaged public func addToMarks(_ value: Marks)

    @objc(removeMarksObject:)
    @NSManaged public func removeFromMarks(_ value: Marks)

    @objc(addMarks:)
    @NSManaged public func addToMarks(_ values: NSSet)

    @objc(removeMarks:)
    @NSManaged public func removeFromMarks(_ values: NSSet)

}
