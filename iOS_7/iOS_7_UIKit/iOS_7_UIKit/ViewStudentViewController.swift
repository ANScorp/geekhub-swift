//
//  ViewStudentViewController.swift
//  iOS_7_UIKit
//
//  Created by Alex on 12/8/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class ViewStudentViewController: UIViewController {

    // MARK: - Properties
    var studentName = ""

    // MARK: - IBOutlets
    @IBOutlet private weak var studentNameTitle: UILabel!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        studentNameTitle.text = studentName
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? EditStudentViewController)?.studentName = studentName
        (segue.destination as? EditStudentViewController)?.delegate = navigationController?.getPreviousViewController()
            as? EditStudentViewControllerDelegate
    }
}
