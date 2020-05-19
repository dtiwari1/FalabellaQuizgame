//
//  RCView.swift
//  InterViewTask
//
//  Created by TalentMicro on 18/05/20.
//  Copyright © 2020 Falabella. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class RCView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupUI()
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            setupUI()
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            setupUI()
        }
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.systemGroupedBackground {
        didSet {
            setupUI()
        }
    }
    func setupUI() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
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
                layer.masksToBounds = false
                self.clipsToBounds = false
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}

@IBDesignable
class GamingView: UIView {
    var gl:CAGradientLayer!
    
    func didMoveToSuperviewz() {
        let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
        self.gl.startPoint = CGPoint(x: 0.0, y: 1.0)
        self.gl.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.gl.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.layer.insertSublayer(gl, at: 0)
    }
    
    
    //    override public func layoutIfNeeded() {
    //        didMoveToSuperview()
    //    }
    
    @IBInspectable var colorTop: UIColor = .white  {
        didSet{
            didMoveToSuperviewz()
        }}
    
    @IBInspectable var colorBottom: UIColor = .white  {
        didSet{
            didMoveToSuperviewz()
        }}
    
}


extension UIView {

func shimmer( ) {
    let gradient = CAGradientLayer()
    gradient.startPoint = CGPoint(x: 0, y: 0)
    gradient.endPoint = CGPoint(x: 1, y: -0.02)
    gradient.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width*3, height: self.bounds.size.height)

    let lowerAlpha: CGFloat = 0.7
    let solid = UIColor(white: 1, alpha: 1).cgColor
    let clear = UIColor(white: 1, alpha: lowerAlpha).cgColor
    gradient.colors     = [ solid, solid, clear, clear, solid, solid ]
    gradient.locations  = [ 0,     0.3,   0.45,  0.55,  0.7,   1     ]

    let theAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
    theAnimation.duration = 2
    theAnimation.repeatCount = 1
    theAnimation.autoreverses = false
    theAnimation.isRemovedOnCompletion = false
    theAnimation.fillMode = CAMediaTimingFillMode.forwards
    theAnimation.fromValue = -self.frame.size.width * 2
    theAnimation.toValue =  0
    gradient.add(theAnimation, forKey: "animateLayer")

    self.layer.mask = gradient
}
}
