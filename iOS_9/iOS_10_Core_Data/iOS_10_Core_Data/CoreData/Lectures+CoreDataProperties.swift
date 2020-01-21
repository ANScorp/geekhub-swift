//
//  Lectures+CoreDataProperties.swift
//  iOS_10_Core_Data
//
//  Created by Alex on 1/14/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//
//

import Foundation
import CoreData


extension Lectures {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lectures> {
        return NSFetchRequest<Lectures>(entityName: "Lectures")
    }

    @NSManaged public var theme: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var homework: Homeworks?
    @NSManaged public var lectors: NSSet?

}

// MARK: Generated accessors for lectors
extension Lectures {

    @objc(addLectorsObject:)
    @NSManaged public func addToLectors(_ value: Lectors)

    @objc(removeLectorsObject:)
    @NSManaged public func removeFromLectors(_ value: Lectors)

    @objc(addLectors:)
    @NSManaged public func addToLectors(_ values: NSSet)

    @objc(removeLectors:)
    @NSManaged public func removeFromLectors(_ values: NSSet)

}
