//
//  EditStudentViewController.swift
//  iOS_7_Custom_Views
//
//  Created by Alex on 12/9/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class EditStudentViewController: UIViewController {
    
    var studentName: String = ""
    var rootViewController: UIViewController?

    @IBOutlet weak var studentNameTextField: UITextField!
    @IBAction func goToRootViewConroller(_ sender: Any) { self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func saveStudentData(_ sender: Any) {
        studentName = studentNameTextField.text!
        let edited = (rootViewController as? StudentsViewController)?.editStudentName(as: studentName)

        if edited ?? false {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentNameTextField.text = studentName
        
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
