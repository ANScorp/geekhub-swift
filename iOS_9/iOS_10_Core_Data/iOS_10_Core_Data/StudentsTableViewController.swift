//
//  StudentsTableViewController.swift
//  iOS_10_Core_Data
//
//  Created by Alex on 1/11/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class StudentsTableViewController: UITableViewController {

    // MARK: - Dependencies

    let coreData = CoreDataStack.shared

    // MARK: - Variables

    lazy var fetchedResultsControllerDelegate = FetchedResultsControllerDelegate(tableView: tableView)

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Students> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Students> = Students.fetchRequest()

        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreData.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = fetchedResultsControllerDelegate

        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    // MARK: - IBAction

    @IBAction private func addNewStudentAction(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Add New Student",
            message: "Fill the fields",
            preferredStyle: UIAlertController.Style.alert
        )

        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter First Name"
        }
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter Second Name"
        }

        let saveAction = UIAlertAction(
            title: "Save",
            style: UIAlertAction.Style.default,
            handler: { _ -> Void in
                let name = alertController.textFields![0] as UITextField
                let surname = alertController.textFields![1] as UITextField
                self.addNewStudent(name: name.text!, surname: surname.text!)
            }
        )
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertAction.Style.default,
            handler: { (action: UIAlertAction!) -> Void in
                alertController.dismiss(animated: true, completion: nil)
                print(#function, action.title!)
            }
        )

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Methods

    func addNewStudent(name: String, surname: String) {
        let student = Students(context: coreData.persistentContainer.viewContext)

        student.name = name
        student.surname = surname
        student.date = Date()
        do {
            try coreData.persistentContainer.viewContext.save()
        } catch {
            debugPrint(error)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        let student = self.fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = "\(student.name ?? "Noname") \(student.surname ?? "Nosurname")"
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let context = coreData.persistentContainer.viewContext
            context.delete(fetchedResultsController.object(at: indexPath))
            try? context.save()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStudentMarksSegue" {
            let indexPath = tableView.indexPathForSelectedRow
            let selectedStudent = self.fetchedResultsController.object(at: indexPath!)
            let marksTableViewController = segue.destination as? MarksTableViewController

            if marksTableViewController != nil {
                marksTableViewController?.selectedStudent = selectedStudent
            }
        }
    }
}
