//
//  MotionView.swift
//  InterViewTask
//
//  Created by TalentMicro on 18/05/20.
//  Copyright © 2020 Falabella. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class MotionViewTextFeild: UITextField {

    override func didMoveToSuperview() {
               let min = CGFloat(motionMinValue)
               let max = CGFloat(motionMaxValue)
                     
               let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
               xMotion.minimumRelativeValue = min
               xMotion.maximumRelativeValue = max
                     
               let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
               yMotion.minimumRelativeValue = min
               yMotion.maximumRelativeValue = max
                     
               let motionEffectGroup = UIMotionEffectGroup()
               motionEffectGroup.motionEffects = [xMotion,yMotion]
        
               self.addMotionEffect(motionEffectGroup)
                 
        
    }
    
    @IBInspectable var motionMinValue:Int = -1{
        didSet{
            didMoveToSuperview()
        }
    }
    
    @IBInspectable var motionMaxValue:Int = 1{
        didSet{
             didMoveToSuperview()
        }
    }
   
    @IBInspectable var addPaddingLeft: CGFloat = 0.0  {
        didSet{
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: addPaddingLeft, height: frame.height))
            leftView = paddingView
            leftViewMode = .always
        }
       
    }
    
    @IBInspectable var placeHolderColor: UIColor = .white  {
        didSet{
            guard let holder = placeholder, !holder.isEmpty else { return }
            attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: placeHolderColor])
        }
        
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       
        
    }
     
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
     
}
 

 
