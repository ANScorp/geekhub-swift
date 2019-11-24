//
//  AutolayoutScreenViewController.swift
//  iOS_5_Autolayout
//
//  Created by Alex on 11/23/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

class AutolayoutScreenViewController: UIViewController {

    @IBOutlet weak var appIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        appIcon.makeRoundCorners(byRadius: 40, borderColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), borderWidth: 4)
        print(#function)
    }

}

extension UIImageView {
    func makeRoundCorners(byRadius rad: CGFloat, borderColor: CGColor, borderWidth: CGFloat) {
        self.layer.cornerRadius = rad
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }
}

@IBDesignable
class DesignableUIImageView: UIImageView {
}

@IBDesignable
class DesignableUIButton: UIButton {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
