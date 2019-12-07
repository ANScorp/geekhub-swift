//
//  StudentsViewController.swift
//  iOS_6_Custom_Views
//
//  Created by Alex on 12/1/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    enum Students: String, CaseIterable {
        static let description = "Students data source"
        case i0 = "Бондар Павло"
        case i1 = "Вождай Ігор"
        case i2 = "Демченко Михайло"
        case i3 = "Запорожець Максим"
        case i4 = "Ілюшенко Ілля"
        case i5 = "Nedopaka Alexander"
        case i6 = "Таченко Дмитро"
        case i7 = "Гуріненко Валентин"
    }
    
    enum StudentsFree: String, CaseIterable {
        static let description = "StudentsFree data source"
        case i0 = "Пухлій Віталій"
        case i1 = "Сагайдак Ілля"
        case i2 = "Шурман Андрій"
        case i3 = "Лавренко Віталій"
        case i4 = "Братчикова Дар'я"
        case i5 = "Крістіна"
    }
    
    enum StudentsRetired: String, CaseIterable {
        static let description = "StudentsRetired data source"
        case i0 = "Горошнюк Вячеслав"
        case i1 = "БЕРЕЗА МАРИНА"
    }
    
    var studentsArr: [String] = []
    var studentsFreeArr: [String] = []
    var studentsRetiredArr: [String] = []
    

    @IBOutlet weak var studentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        for index in 0..<Students.allCases.count {
//            studentsArr.append(Students.allCases[index].rawValue)
//        }
//        for index in 0..<StudentsFree.allCases.count {
//            studentsFreeArr.append(StudentsFree.allCases[index].rawValue)
//        }
//        for index in 0..<StudentsRetired.allCases.count {
//            studentsRetiredArr.append(StudentsRetired.allCases[index].rawValue)
//        }
        studentsArr = Students.allCases.map { $0.rawValue }
        studentsFreeArr = StudentsFree.allCases.map { $0.rawValue }
        studentsRetiredArr = StudentsRetired.allCases.map { $0.rawValue }
        studentsTableView.rowHeight = 44
        print(#function)
    }
    

}

// MARK: - UITableViewDataSource
extension StudentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
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
        print(#function)
        switch indexPath.section {
            case 0:
                let value = studentsArr[indexPath.row]
                let cell = studentsTableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
                cell.textLabel?.text = value
                return cell
            case 1:
                let value = studentsFreeArr[indexPath.row]
                let cell = studentsTableView.dequeueReusableCell(withIdentifier: "StudentFreeCell", for: indexPath) as! StudentFreeCell
                cell.nameLabel.text = value
                cell.tapCallback = {
                    self.addToStudents(fromIndexPath: indexPath)
                }
                return cell
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
        print(#function)
        switch section {
            case 0:
                return "Students"
            case 1:
                return "Free listeners"
            case 2:
                return "Retired"
            default:
                return ""
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let valueToDelete: String
        let indexPaths4Insert: [IndexPath]
        if editingStyle == .delete {
            print("Delete button touched")
            switch indexPath.section {
            case 0:
                valueToDelete = studentsArr[indexPath.row]
                studentsArr.remove(at: indexPath.row)
                studentsFreeArr += [valueToDelete]
                indexPaths4Insert = (studentsFreeArr.count - [valueToDelete].count..<studentsFreeArr.count).map { IndexPath(row: $0, section: 1) }
            case 1:
                valueToDelete = studentsFreeArr[indexPath.row]
                studentsFreeArr.remove(at: indexPath.row)
                studentsRetiredArr += [valueToDelete]
                indexPaths4Insert = (studentsRetiredArr.count - [valueToDelete].count..<studentsRetiredArr.count).map { IndexPath(row: $0, section: 2) }
            case 2:
                valueToDelete = studentsRetiredArr[indexPath.row]
                studentsRetiredArr.remove(at: indexPath.row)
                indexPaths4Insert = []
            default:
                return
            }
            studentsTableView.beginUpdates()
            studentsTableView.deleteRows(at: [indexPath], with: .fade)
            studentsTableView.insertRows(at: indexPaths4Insert, with: .right)
            studentsTableView.endUpdates()
            //studentsTableView.reloadData()
            print("Item to delete: '\(valueToDelete)' at position: \(indexPath)")
            print("Item to insert: '\(valueToDelete)' at position: \(indexPaths4Insert)")
            
        }
    }
    
    func addToStudents(fromIndexPath: IndexPath) -> Void {
        print("Callback triggered")
        let valueToDelete = studentsFreeArr[fromIndexPath.row]
        print("Item to delete: '\(valueToDelete)' at position: \(fromIndexPath)")
        studentsFreeArr.remove(at: fromIndexPath.row)
        studentsArr += [valueToDelete]
        let indexPath4Insert = IndexPath(row: studentsArr.count -  1, section: 0)
        studentsTableView.beginUpdates()
        studentsTableView.deleteRows(at: [fromIndexPath], with: .fade)
        studentsTableView.insertRows(at: [indexPath4Insert], with: .right)
        studentsTableView.endUpdates()
        self.perform(#selector(reloadTable), with: nil, afterDelay: 1)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.textLabel?.text = "Index path: section \(indexPath.section) row \(indexPath.row)"
//        (cell as? StudentFreeCell)?.tapCallback = {
//            self.addToStudents(fromIndexPath: indexPath)
//        }
    }
    
    @objc func reloadTable() {
        // all interface updates should be performed in main thread only
        // 'sync' blocks the main thread until the task has finished
        // 'async' means that this will happen on a background thread and update the main thread when it's finished
        DispatchQueue.main.async {
            self.studentsTableView.reloadData()
        }
    }
}
