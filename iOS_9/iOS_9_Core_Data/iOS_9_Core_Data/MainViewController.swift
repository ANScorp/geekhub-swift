//
//  MainViewController.swift
//  iOS_9_Core_Data
//
//  Created by Alex on 12/23/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Dependencies
    let coreData = CoreDataStack.shared

    // MARK: - Properties
    var groupCounter = 0
    var lectorCounter = 0
    var studentCounter = 0
    var projectCounter = 0

    // MARK: - IBOutlets
    @IBOutlet private weak var groupsTextView: UITextView!
    @IBOutlet private weak var lectorsTextView: UITextView!
    @IBOutlet private weak var studentsTextView: UITextView!
    @IBOutlet private weak var projectsTextView: UITextView!

    // MARK: - IBOutlets
    @IBAction private func addNewGroup(_ sender: Any) {
        let group = Group(context: coreData.persistentContainer.viewContext)
        group.name = "Group \(groupCounter)"
        do {
            try coreData.persistentContainer.viewContext.save()
        } catch {
            debugPrint(error)
        }
        groupsTextView.text += group.name!
        groupsTextView.text += "\n"
        groupCounter += 1
    }

    @IBAction private func addNewLector(_ sender: Any) {
        let lector = Lector(context: coreData.persistentContainer.viewContext)
        lector.name = "Lector \(lectorCounter)"
        do {
            try coreData.persistentContainer.viewContext.save()
        } catch {
            debugPrint(error)
        }
        lectorsTextView.text += lector.name!
        lectorsTextView.text += "\n"
        lectorCounter += 1
    }

    @IBAction private func addNewStudent(_ sender: Any) {
        let student = Student(context: coreData.persistentContainer.viewContext)
        student.name = "Student \(lectorCounter)"
        do {
            try coreData.persistentContainer.viewContext.save()
        } catch {
            debugPrint(error)
        }
        studentsTextView.text += student.name!
        studentsTextView.text += "\n"
        studentCounter += 1
    }

    @IBAction private func addNewProject(_ sender: Any) {
        let project = Lector(context: coreData.persistentContainer.viewContext)
        project.name = "Project \(lectorCounter)"
        do {
            try coreData.persistentContainer.viewContext.save()
        } catch {
            debugPrint(error)
        }
        projectsTextView.text += project.name!
        projectsTextView.text += "\n"
        projectCounter += 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTextView.text = ""
        lectorsTextView.text = ""
        studentsTextView.text = ""
        projectsTextView.text = ""
        UIView.animate(withDuration: 2, animations: {
            self.view.backgroundColor = .yellow
        })
    }
}
