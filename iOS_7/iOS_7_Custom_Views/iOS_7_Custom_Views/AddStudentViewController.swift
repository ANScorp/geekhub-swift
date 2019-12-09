//
//  AddStudentViewController.swift
//  iOS_7_Custom_Views
//
//  Created by Alex on 12/8/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class AddStudentViewController: UIViewController {
    
    var sections: [String: UIImage] = [:]
    var selectedSection = ""
    var studentName = ""
    var addStudentCallback: (() -> Void)?
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var sectionsPickerView: UIPickerView!
    
    @IBAction func addStudent(_ sender: UIButton) {
        let selectedRow = sectionsPickerView.selectedRow(inComponent: 0)
        selectedSection = sectionsPickerView.view(forRow: selectedRow, forComponent: 0)?.accessibilityIdentifier ?? ""
        studentName = studentNameTextField.text ?? ""
        addStudentCallback?()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToPreviousView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(sections)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddStudentViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sections.count > 0 ? sections.count : 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        60
    }
    
}

extension AddStudentViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let itemView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
        let itemImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        var rowString = String()
//        switch row {
//        case 0:
//            rowString = "Students"
//            itemImageView.image = #imageLiteral(resourceName: "Students")
//        case 1:
//            rowString = "Free Listeners"
//            itemImageView.image = #imageLiteral(resourceName: "StudentsFree")
//        case 2:
//            rowString = "Retired"
//            itemImageView.image = #imageLiteral(resourceName: "StudentsRetired")
//        default:
//            rowString = "Too many rows"
//            itemImageView.image = nil
//        }
        if sections.count > 0 {
            rowString = Array(sections)[row].key
            itemImageView.image = Array(sections)[row].value
            
        } else {
            rowString = "No sections"
            itemImageView.image = nil
        }
        let itemLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60))
        itemLabel.font = UIFont(name: "System", size: 18)
        itemLabel.text = rowString
        
        itemView.addSubview(itemImageView)
        itemView.addSubview(itemLabel)
        itemView.tag = row
        itemView.accessibilityIdentifier = itemLabel.text ?? ""
        
        return itemView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(#function)
        let tag = pickerView.view(forRow: row, forComponent: component)?.tag
        let accessibilityIdentifier = pickerView.view(forRow: row, forComponent: component)?.accessibilityIdentifier
        print("Selected row tag is \(tag ?? -1) with accessibilityIdentifier: \(String(describing: accessibilityIdentifier))")
    }
}
