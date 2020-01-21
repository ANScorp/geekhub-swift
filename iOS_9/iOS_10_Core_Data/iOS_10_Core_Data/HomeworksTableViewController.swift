//
//  HomeworksTableViewController.swift
//  iOS_10_Core_Data
//
//  Created by Alex on 1/19/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class HomeworksTableViewController: UITableViewController {

    // MARK: - Dependencies

    let coreData = CoreDataStack.shared

    // MARK: - Variables

    lazy var fetchedResultsControllerDelegate = FetchedResultsControllerDelegate(tableView: tableView)

    lazy var lecturesFetchRequest: NSFetchRequest<Lectures> = Lectures.fetchRequest()
    var lectures: [Lectures]?
    var selectedLecture: Lectures?
    var textFieldLecturePicker: UITextField?
    var lecturePickerView: UIPickerView?

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Homeworks> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Homeworks> = Homeworks.fetchRequest()

        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
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

    // MARK: - IBActions

    @IBAction private func addNewHomeworkAction(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Add New Homework",
            message: "Fill the fields",
            preferredStyle: UIAlertController.Style.alert
        )

        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Task"
        }
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Choose lecture"

            let sortDescriptor = NSSortDescriptor(key: "theme", ascending: true)
            self.lecturesFetchRequest.sortDescriptors = [sortDescriptor]
            self.lectures = try? self.coreData.persistentContainer.viewContext.fetch(self.lecturesFetchRequest)

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

            self.textFieldLecturePicker = textField
            self.lecturePickerView = pickerView
        }

        let saveAction = UIAlertAction(
            title: "Save",
            style: UIAlertAction.Style.default,
            handler: { _ -> Void in
                let task = alertController.textFields![0] as UITextField

                self.addNewHomework(task: task.text!, lecture: self.selectedLecture!)
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
        selectedLecture = lectures?[lecturePickerView?.selectedRow(inComponent: 0) ?? 0]
        textFieldLecturePicker?.text = "\(selectedLecture!.theme!)"
        textFieldLecturePicker?.resignFirstResponder()
    }

    func addNewHomework(task: String, lecture: Lectures) {
        let homework = Homeworks(context: coreData.persistentContainer.viewContext)

        homework.task = task
        homework.lecture = lecture
        homework.timestamp = Date()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeworksCell", for: indexPath)
        let homework = self.fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = "\(homework.task ?? "No task")"
        cell.detailTextLabel?.text = homework.lecture?.theme
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

extension HomeworksTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lectures!.count
    }
}

// MARK: - UIPickerViewDelegate

extension HomeworksTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(lectures?[row].theme ?? "No theme")"
    }
}
