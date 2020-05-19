//
//  MotionViewButton.swift
//  InterViewTask
//
//  Created by TalentMicro on 18/05/20.
//  Copyright © 2020 Falabella. All rights reserved.
//

import UIKit
@IBDesignable
class MotionViewButton: UIButton {
 
    
    override func didMoveToSuperview() {
        updateView()
    }
   
    func  updateView(){
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
        
}
