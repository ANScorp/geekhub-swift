//
//  StudentFreeCell.swift
//  iOS_7_UIKit
//
//  Created by Alex on 12/1/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class StudentFreeCell: UITableViewCell {

    // MARK: - Properties
    var displayName: String {
        get {
            nameLabel.text ?? ""
        }
        set {
            nameLabel.text = newValue
        }
    }

    var moveToStudentsCallback: (() -> Void)?

    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - IBActions
    @IBAction private func addToStudentsBtn(_ sender: UIButton) {
        moveToStudentsCallback?()
    }

    // MARK: - Life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        moveToStudentsCallback = nil
    }
}
