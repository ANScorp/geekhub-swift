//
//  Lectors+CoreDataProperties.swift
//  iOS_10_Core_Data
//
//  Created by Alex on 1/14/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//
//

import Foundation
import CoreData


extension Lectors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lectors> {
        return NSFetchRequest<Lectors>(entityName: "Lectors")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var lectures: NSSet?

}

// MARK: Generated accessors for lectures
extension Lectors {

    @objc(addLecturesObject:)
    @NSManaged public func addToLectures(_ value: Lectures)

    @objc(removeLecturesObject:)
    @NSManaged public func removeFromLectures(_ value: Lectures)

    @objc(addLectures:)
    @NSManaged public func addToLectures(_ values: NSSet)

    @objc(removeLectures:)
    @NSManaged public func removeFromLectures(_ values: NSSet)

}
