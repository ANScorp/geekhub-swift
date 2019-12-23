//
//  Project+CoreDataProperties.swift
//  iOS_9_Core_Data
//
//  Created by Alex on 12/23/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//
//

import Foundation
import CoreData

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var theme: String?
    @NSManaged public var student: Student?
}
