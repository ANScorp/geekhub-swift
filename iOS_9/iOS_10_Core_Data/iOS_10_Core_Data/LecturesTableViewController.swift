//
//  LecturesTableViewController.swift
//  iOS_10_Core_Data
//
//  Created by Alex on 1/14/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class LecturesTableViewController: UITableViewController {

    // MARK: - Dependencies

    let coreData = CoreDataStack.shared

    // MARK: - Variables

    lazy var fetchedResultsControllerDelegate = FetchedResultsControllerDelegate(tableView: tableView)

    lazy var lectorsFetchRequest: NSFetchRequest<Lectors> = Lectors.fetchRequest()
    var lectors: [Lectors]?
    var selectedLector: Lectors?
    var textFieldLectorPicker: UITextField?
    var lectorsPickerView: UIPickerView?

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Lectures> = {
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<Lectures> = Lectures.fetchRequest()

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

    @IBAction private func addNewLectureAction(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Add New Lecture",
            message: "Fill the fields",
            preferredStyle: UIAlertController.Style.alert
        )

        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Theme"
        }
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Choose lector"

            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            self.lectorsFetchRequest.sortDescriptors = [sortDescriptor]
            self.lectors = try? self.coreData.persistentContainer.viewContext.fetch(self.lectorsFetchRequest)

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

            self.textFieldLectorPicker = textField
            self.lectorsPickerView = pickerView
        }

        let saveAction = UIAlertAction(
            title: "Save",
            style: UIAlertAction.Style.default,
            handler: { _ -> Void in
                let theme = alertController.textFields![0] as UITextField
                let lector = alertController.textFields![1] as UITextField

                self.addNewLecture(theme: theme.text!, lector: lector.text!)
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
        selectedLector = lectors?[lectorsPickerView?.selectedRow(inComponent: 0) ?? 0]
        textFieldLectorPicker?.text = "\(selectedLector!.name!) \(selectedLector!.surname!)"
        textFieldLectorPicker?.resignFirstResponder()
    }

    func addNewLecture(theme: String, lector: String) {
        let lecture = Lectures(context: coreData.persistentContainer.viewContext)
        lecture.theme = theme
        lecture.lectors = NSSet(object: selectedLector!)
        lecture.timestamp = Date()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LecturesCell", for: indexPath)
        let lecture = self.fetchedResultsController.object(at: indexPath)
        var lectorsArr = [String]()

        for lector in lecture.lectors?.allObjects as! [Lectors] {
            lectorsArr += ["\(lector.name!) \(lector.surname!)"]
        }
        cell.textLabel?.text = "\(lecture.theme ?? "No theme")"
        cell.detailTextLabel?.text = lectorsArr.reduce("Lectors:") { title, lectors in "\(title!) \(lectors)" }
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

extension LecturesTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lectors!.count
    }
}

// MARK: - UIPickerViewDelegate

extension LecturesTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(lectors?[row].name ?? "Noname") \(lectors?[row].surname ?? "Nosurname")"
    }
}
