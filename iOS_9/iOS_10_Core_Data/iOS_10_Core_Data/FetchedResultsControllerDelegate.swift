//
//  FetchedResultsControllerDelegate.swift
//  iOS_10_Core_Data
//
//  Created by Alex on 1/20/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import UIKit
import CoreData

final class FetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
    weak var tableView: UITableView?

    convenience init(tableView: UITableView) {
        self.init()
        self.tableView = tableView
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .insert:
            tableView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            tableView?.insertRows(at: [newIndexPath!], with: .top)
        case .delete:
            tableView?.deleteRows(at: [indexPath!], with: .bottom)
        case .update:
            tableView?.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView?.reloadRows(at: [indexPath!], with: .fade)
            tableView?.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}
