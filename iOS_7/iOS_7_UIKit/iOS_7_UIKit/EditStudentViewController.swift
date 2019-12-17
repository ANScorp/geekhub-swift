//
//  EditStudentViewController.swift
//  iOS_7_UIKit
//
//  Created by Alex on 12/9/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

// MARK: - EditStudentViewControllerDelegate
protocol EditStudentViewControllerDelegate: class {
    func editStudentName(as name: String) -> Bool
}

// MARK: - EditStudentViewController
class EditStudentViewController: UIViewController {

    // MARK: - Properties
    var studentName: String = ""
    weak var delegate: EditStudentViewControllerDelegate?

    // MARK: - IBOutlets
    @IBOutlet private weak var studentNameTextField: UITextField!

    // MARK: - IBActions
    @IBAction private func goToRootViewConroller
        (_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction private func saveStudentData(_ sender: Any) {
        studentName = studentNameTextField.text!

        let edited = delegate?.editStudentName(as: studentName)
        if edited ?? false {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        studentNameTextField.text = studentName
    }
}
