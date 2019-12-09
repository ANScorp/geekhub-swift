//
//  StudentFreeCell.swift
//  iOS_7_Custom_Views
//
//  Created by Alex on 12/1/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class StudentFreeCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var tapCallback: (() -> Void)?
    
    @IBAction func addToStudentsBtn(_ sender: UIButton) {
        print("Button touched")
        tapCallback?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tapCallback = nil
        print("StudentFreeCell \(#function)")
    }

}
