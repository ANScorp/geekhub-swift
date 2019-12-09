//
//  ViewStudentViewController.swift
//  iOS_7_Custom_Views
//
//  Created by Alex on 12/8/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class ViewStudentViewController: UIViewController {
    
    var studentName = ""
    var rootViewController: UIViewController?

    @IBOutlet weak var studentNameTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentNameTitle.text = studentName
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? EditStudentViewController)?.studentName = studentName
        (segue.destination as? EditStudentViewController)?.rootViewController = rootViewController
    }

}
