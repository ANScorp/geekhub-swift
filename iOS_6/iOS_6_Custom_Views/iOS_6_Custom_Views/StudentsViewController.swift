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
    }
    
    enum StudentsFree: String, CaseIterable {
        static let description = "StudentsFree data source"
        case i0 = "Пухлій Віталій"
        case i1 = "Сагайдак Ілля"
        case i2 = "Шурман Андрій"
        case i3 = "Лавренко Віталій"
        case i4 = "Братчикова Дар'я"
        case i5 = "Крістіна"
        case i6 = "Гуріненко Валентин"
    }
    
    enum StudentsRetired: String, CaseIterable {
        static let description = "StudentsRetired data source"
        case i0 = "Горошнюк Вячеслав"
        case i1 = "БЕРЕЗА МАРИНА"
    }

    @IBOutlet weak var studentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
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
                return Students.allCases.count
            case 1:
                return StudentsFree.allCases.count
            case 2:
                return StudentsRetired.allCases.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let value = Students.allCases[indexPath.row].rawValue
                let cell = studentsTableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
                cell.textLabel?.text = value
                return cell
            case 1:
                let value = StudentsFree.allCases[indexPath.row].rawValue
                let cell = studentsTableView.dequeueReusableCell(withIdentifier: "StudentFreeCell", for: indexPath) as! StudentFreeCell
                cell.nameLabel.text = value
            return cell
            case 2:
                let value = StudentsRetired.allCases[indexPath.row].rawValue
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
        if editingStyle == .delete {
            print("Delete button touched")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.textLabel?.text = "Index path: section \(indexPath.section) row \(indexPath.row)"
    }
}
