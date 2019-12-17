//
//  AddStudentViewController.swift
//  iOS_7_UIKit
//
//  Created by Alex on 12/8/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class AddStudentViewController: UIViewController {

    // MARK: - Properties
    var sections: [(name: String, image: UIImage)] = []
    var selectedSection = ""
    var studentName = ""
    var addStudentCallback: (() -> Void)?

    // MARK: - IBOutlets
    @IBOutlet private weak var studentNameTextField: UITextField!
    @IBOutlet private weak var sectionsPickerView: UIPickerView!

    // MARK: - IBActions
    @IBAction private func addStudent(_ sender: UIButton) {
        let selectedRow = sectionsPickerView.selectedRow(inComponent: 0)

        selectedSection = sectionsPickerView.view(forRow: selectedRow, forComponent: 0)?.accessibilityIdentifier ?? ""
        studentName = studentNameTextField.text ?? ""
        addStudentCallback?()
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func goToPreviousView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDataSource
extension AddStudentViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        !sections.isEmpty ? sections.count : 0
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        60
    }
}

// MARK: - UIPickerViewDelegate
extension AddStudentViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        let itemView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
        let itemImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        let itemLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 90, height: 60))
        var rowString = String()

        if !sections.isEmpty {
            rowString = sections[row].name
            itemImageView.image = sections[row].image
        } else {
            rowString = "No sections"
            itemImageView.image = nil
        }

        itemLabel.font = UIFont(name: "System", size: 18)
        itemLabel.text = rowString

        itemView.addSubview(itemImageView)
        itemView.addSubview(itemLabel)
        itemView.tag = row
        itemView.accessibilityIdentifier = itemLabel.text ?? ""

        return itemView
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tag = pickerView.view(forRow: row, forComponent: component)?.tag
        let accessibilityIdentifier = pickerView.view(forRow: row, forComponent: component)?.accessibilityIdentifier
        print("Selected row tag is \(tag ?? -1) with " +
            "accessibilityIdentifier: \(String(describing: accessibilityIdentifier))")
    }
}
