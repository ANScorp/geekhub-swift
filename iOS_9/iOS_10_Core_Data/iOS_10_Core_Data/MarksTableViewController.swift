//
//  MarksTableViewController.swift
//  iOS_10_Core_Data
//
//  Created by Alex on 1/20/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class MarksTableViewController: UITableViewController {

    // MARK: - Dependencies

    let coreData = CoreDataStack.shared

    // MARK: - Variables

    lazy var fetchedResultsControllerDelegate = FetchedResultsControllerDelegate(tableView: tableView)

    lazy var homeworksFetchRequest: NSFetchRequest<Homeworks> = Homeworks.fetchRequest()
    var homeworks: [Homeworks]?
    var selectedStudent: Students?
    var selectedHomework: Homeworks?
    var textFieldHomeworkPicker: UITextField?
    var homeworkPickerView: UIPickerView?

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Marks> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Marks> = Marks.fetchRequest()

        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        let predicate = NSPredicate(format: "student = %@", selectedStudent!)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate

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

    // MARK: - IBActions

    @IBAction private func addNewMarkAction(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Add New Mark",
            message: "Fill the fields",
            preferredStyle: UIAlertController.Style.alert
        )

        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Mark"
        }
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Clarification"
        }
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Choose homework"

            let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
            self.homeworksFetchRequest.sortDescriptors = [sortDescriptor]
            self.homeworks = try? self.coreData.persistentContainer.viewContext.fetch(self.homeworksFetchRequest)

            let pickerView = UIPickerView()
            pickerView.dataSource = self
            pickerView.delegate = self

            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true

            let doneButton = UIBarButtonItem(
                title: "Done",
                style: UIBarButtonItem.Style.done,
                target: self,
                action: #selector(self.dismissPickerPressed)
            )
            let spaceButton = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
                target: nil,
                action: nil
            )
            toolBar.setItems([doneButton, spaceButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            toolBar.sizeToFit()

            textField.inputAccessoryView = toolBar
            textField.inputView = pickerView

            self.textFieldHomeworkPicker = textField
            self.homeworkPickerView = pickerView
        }

        let saveAction = UIAlertAction(
            title: "Save",
            style: UIAlertAction.Style.default,
            handler: { _ -> Void in
                let mark = alertController.textFields![0] as UITextField
                let clarification = alertController.textFields![1] as UITextField
                self.addNewMark(
                    student: self.selectedStudent!,
                    homework: self.selectedHomework!,
                    mark: mark.text!,
                    clarification: clarification.text!
                )
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

    @objc func dismissPickerPressed() {
        selectedHomework = homeworks?[homeworkPickerView?.selectedRow(inComponent: 0) ?? 0]
        textFieldHomeworkPicker?.text = "\(selectedHomework!.task!) - \(selectedHomework!.lecture?.theme ?? "No theme")"
        textFieldHomeworkPicker?.resignFirstResponder()
    }

    func addNewMark(student: Students, homework: Homeworks, mark: String, clarification: String) {
        let newMark = Marks(context: coreData.persistentContainer.viewContext)

        newMark.student = student
        newMark.homework = homework
        newMark.mark = mark
        newMark.clarification = clarification
        newMark.timestamp = Date()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarksCell", for: indexPath)
        let mark = self.fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = "\(mark.mark ?? "No mark")"
        cell.detailTextLabel?.text = "\(mark.clarification!) - \(mark.homework?.task ?? "No task")"
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
}

// MARK: - UIPickerViewDataSource

extension MarksTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        homeworks!.count
    }
}

// MARK: - UIPickerViewDelegate

extension MarksTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(homeworks?[row].task ?? "No task") - \(homeworks?[row].lecture?.theme ?? "No theme")"
    }
}
