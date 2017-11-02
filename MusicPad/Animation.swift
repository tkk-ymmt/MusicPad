//
//  Animation.swift
//  MusicPad
//
//  Created by motoki on 2017/09/15.
//  Copyright © 2017年 motoki. All rights reserved.
//

import Foundation
import UIKit

protocol Animation: ColorNode, ActionNode, PatternNode, TimeNode {
    func animationGen(tag: Int, scaleButtonArray: [ScaleButton])
}

extension Animation {
    func animationGen(tag: Int, scaleButtonArray: [ScaleButton]) {
        let color = colorNodeGen()
        let action = actionNodeGen()
        let pattern = patternNodeGen(tag: tag)
        let simultaniouly = timeNodeGen()
        
        var animationArray: [CAAnimationGroup] = []
        
        if simultaniouly {
            //simultaniously
            for _ in 0 ..< pattern.count {
                let animation = CAAnimationGroup()
                animation.fillMode = kCAFillModeBackwards
                animation.isRemovedOnCompletion = true
                animation.animations = [color, action]

                animationArray.append(animation)
            }

        } else {
            //successively
            for i in 0 ..< pattern.count {
                let animation = CAAnimationGroup()
                animation.fillMode = kCAFillModeBackwards
                animation.isRemovedOnCompletion = true
                animation.animations = [color, action]
                
                animation.beginTime = CACurrentMediaTime() + Double(i)*0.04
                animationArray.append(animation)
            }
        }
        
        // perform animation
        var k: Int = 0
        for element in pattern {
            scaleButtonArray[element].layer.add(animationArray[k], forKey: nil)
            k += 1
        }
    }
}
