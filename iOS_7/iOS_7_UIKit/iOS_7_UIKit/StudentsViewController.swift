//
//  StudentsViewController.swift
//  iOS_7_UIKit
//
//  Created by Alex on 12/1/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {

    // MARK: - Properties
    let sections = [
        (name: "Students", image: #imageLiteral(resourceName: "Students")),
        (name: "Free listeners", image: #imageLiteral(resourceName: "StudentsFree")),
        (name: "Retired", image: #imageLiteral(resourceName: "StudentsRetired"))
    ]

    var studentsArr = [
        "Бондар Павло",
        "Вождай Ігор",
        "Демченко Михайло",
        "Запорожець Максим",
        "Ілюшенко Ілля",
        "Nedopaka Alexander",
        "Таченко Дмитро",
        "Гуріненко Валентин"
    ]

    var studentsFreeArr = [
        "Пухлій Віталій",
        "Сагайдак Ілля",
        "Шурман Андрій",
        "Лавренко Віталій",
        "Братчикова Дар'я",
        "Крістіна"
    ]

    var studentsRetiredArr = [
        "Горошнюк Вячеслав",
        "БЕРЕЗА МАРИНА"
    ]

    var selectedSectionIndex: Int?
    var selectedRowIndex: Int?

    // MARK: - IBOutlets
    @IBOutlet private weak var studentsTableView: UITableView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        studentsTableView.rowHeight = 44
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddStudentSegue" {
            let addStudentViewController = segue.destination as? AddStudentViewController
            if addStudentViewController != nil {
                addStudentViewController?.sections = sections
                addStudentViewController?.addStudentCallback = {
                    let selectedSection = addStudentViewController?.selectedSection
                    let studentName = addStudentViewController?.studentName
                    let added = self.addStudent(to: selectedSection ?? "", as: studentName ?? "")
                    if added {
                        self.studentsTableView.reloadData()
                    }
                }
            }
        }
        if segue.identifier == "ShowStudentDataSegue" {
            let selectedRow = studentsTableView.indexPathForSelectedRow?.row
            let studentName = studentsArr[selectedRow!]
            let viewStudentViewController = segue.destination as? ViewStudentViewController

            if viewStudentViewController != nil {
                viewStudentViewController?.studentName = studentName
            }
        }
    }

    // MARK: - method for adding new student with specified name to specific section
    func addStudent(to section: String, as name: String) -> Bool {
        switch section {
        case "Students":
            studentsArr += [name]
        case "Free listeners":
            studentsFreeArr += [name]
        case "Retired":
            studentsRetiredArr += [name]
        default:
            return false
        }
        return true
    }
}

// MARK: - EditStudentViewControllerDelegate
extension StudentsViewController: EditStudentViewControllerDelegate {

    // MARK: - method for existing student name editing
    func editStudentName(as newName: String) -> Bool {
        switch selectedSectionIndex {
        case 0:
            studentsArr[selectedRowIndex!] = newName
        case 1:
            studentsFreeArr[selectedRowIndex!] = newName
        case 2:
            studentsRetiredArr[selectedRowIndex!] = newName
        default:
            return false
        }
        studentsTableView.reloadData()
        return true
    }
}

// MARK: - UINavigationController
extension UINavigationController {
    func getPreviousViewController() -> UIViewController? {
        let count = viewControllers.count
        guard count > 1 else {
            return nil
        }
        return viewControllers[count - 2]
    }
}

// MARK: - UITableViewDataSource
extension StudentsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return studentsArr.count
        case 1:
            return studentsFreeArr.count
        case 2:
            return studentsRetiredArr.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let value = studentsArr[indexPath.row]
            let cell = studentsTableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
            cell.textLabel?.text = value
            return cell
        case 1:
            let value = studentsFreeArr[indexPath.row]
            let cell = studentsTableView.dequeueReusableCell(withIdentifier: "StudentFreeCell", for: indexPath)
                as? StudentFreeCell
            cell?.displayName = value
            return cell ?? studentsTableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        case 2:
            let value = studentsRetiredArr[indexPath.row]
            let cell = studentsTableView.dequeueReusableCell(withIdentifier: "StudentRetiredCell", for: indexPath)
            cell.textLabel?.text = value
            return cell
        default:
            return studentsTableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        }
    }
}

// MARK: - UITableViewDelegate
extension StudentsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].name
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let valueToDelete: String
        let indexPathsForInsert: [IndexPath]

        guard editingStyle == .delete else {
            return
        }
        switch indexPath.section {
        case 0:
            valueToDelete = studentsArr[indexPath.row]
            studentsArr.remove(at: indexPath.row)
            studentsFreeArr += [valueToDelete]
            indexPathsForInsert = (studentsFreeArr.count - [valueToDelete].count..<studentsFreeArr.count)
                .map { IndexPath(row: $0, section: 1) }
        case 1:
            valueToDelete = studentsFreeArr[indexPath.row]
            studentsFreeArr.remove(at: indexPath.row)
            studentsRetiredArr += [valueToDelete]
            indexPathsForInsert = (studentsRetiredArr.count - [valueToDelete].count..<studentsRetiredArr.count)
                .map { IndexPath(row: $0, section: 2) }
        case 2:
            valueToDelete = studentsRetiredArr[indexPath.row]
            studentsRetiredArr.remove(at: indexPath.row)
            indexPathsForInsert = []
        default:
            return
        }
        studentsTableView.beginUpdates()
        studentsTableView.deleteRows(at: [indexPath], with: .fade)
        studentsTableView.insertRows(at: indexPathsForInsert, with: .right)
        studentsTableView.endUpdates()
    }

    /// ATTENTION: didSelectRowAt method will trigger only after execution of assigned to cell segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        var cellValue: String
        let viewStudentViewController = UIStoryboard(name: "Students", bundle: nil)
            .instantiateViewController(withIdentifier: "ViewStudentViewController")
            as? ViewStudentViewController

        switch indexPath.section {
        case 0:
            cellValue = studentsArr[index]
        case 1:
            cellValue = studentsFreeArr[index]
        case 2:
            cellValue = studentsRetiredArr[index]
        default:
            cellValue = "Unknown"
        }

        if [1, 2].contains(indexPath.section) {
            viewStudentViewController?.studentName = cellValue
            navigationController?.pushViewController(viewStudentViewController ?? UIViewController(), animated: true)
        }
        selectedSectionIndex = indexPath.section
        selectedRowIndex = index
    }

    // MARK: - method for moving data to Students section with displaying of the result
    func moveToStudents(fromIndexPath: IndexPath) {
        let valueToDelete = studentsFreeArr[fromIndexPath.row]
        let indexPathForInsert: IndexPath

        studentsFreeArr.remove(at: fromIndexPath.row)
        studentsArr += [valueToDelete]
        indexPathForInsert = IndexPath(row: studentsArr.count - 1, section: 0)
        studentsTableView.beginUpdates()
        studentsTableView.deleteRows(at: [fromIndexPath], with: .fade)
        studentsTableView.insertRows(at: [indexPathForInsert], with: .right)
        studentsTableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? StudentFreeCell)?.moveToStudentsCallback = {
            self.moveToStudents(fromIndexPath: tableView.indexPath(for: cell)!)
        }
    }
}
