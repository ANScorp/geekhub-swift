//
//  DisplayUIControlsViewController.swift
//  iOS_4_UIKit
//
//  Created by Alex on 11/16/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class DisplayUIControlsViewController: UIViewController {
    var systemBtnTouchCount = 0
    var nestedView: UIView?

    @IBOutlet weak var systemBtnLinkedLabel: UILabel!
    @IBOutlet weak var segmentedControlLinkedLabel: UILabel!
    @IBOutlet weak var textFieldLinkedLabel: UILabel!
    @IBOutlet weak var sliderLinkedLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var stepperLinkedLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var changeViewAlphaSlider: UISlider!
    
    @IBAction func systemBtnTouched(_ sender: UIButton) {
        systemBtnTouchCount += 1
        systemBtnLinkedLabel.text = "Touches count: \(systemBtnTouchCount)"
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        segmentedControlLinkedLabel.text = sender.titleForSegment(at: sender.selectedSegmentIndex)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        textFieldLinkedLabel.text = sender.text
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderLinkedLabel.text = String(sender.value)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            view.backgroundColor = #colorLiteral(red: 0.8592077618, green: 1, blue: 0.6330469662, alpha: 1)
        } else {
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }

    @IBAction func hitToSpinBtnTouched(_ sender: UIButton) {
        spinner.startAnimating()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        stepperLinkedLabel.text = String(sender.value)
    }
    
    @IBAction func loadImgBtnTouched(_ sender: UIButton) {
        imageView.image = #imageLiteral(resourceName: "Image")
    }
    
    @objc func changeViewAlphaOnSliderValueChanged(_ sender: UISlider) {
        nestedView?.alpha = 1 - CGFloat(sender.value)
    }
    
    @IBAction func colorBtnTouchDragUpOutside(_ sender: UIButton) {
        sender.backgroundColor = .random
    }
    
    @IBAction func colorBtnTouchDown(_ sender: UIButton) {
        sender.setTitleColor(.random, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sliderRect = changeViewAlphaSlider.frame
        let nestedViewRect = CGRect(x: sliderRect.origin.x, y: sliderRect.origin.y + 50, width: view.frame.size.width - 70, height: 130)
        nestedView = UIView(frame: nestedViewRect)
        nestedView?.layer.cornerRadius = 9
        nestedView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        changeViewAlphaSlider.addTarget(self, action: #selector(changeViewAlphaOnSliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(nestedView!)
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    deinit {
        print(#function)
    }

}

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}
