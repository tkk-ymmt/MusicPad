//
//  ActionNode.swift
//  MusicPad
//
//  Created by motoki on 2017/11/01.
//  Copyright © 2017年 motoki. All rights reserved.
//

import Foundation
import UIKit

protocol ActionNode {
    var springAction: CABasicAnimation { get }
    var transAction:  CABasicAnimation { get }
    
    func actionNodeGen() -> CABasicAnimation
}


extension ActionNode {
    
    var springAction: CABasicAnimation {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.2
        springAnimation.initialVelocity = 5
        springAnimation.fromValue = 1.10
        springAnimation.toValue = 1.0
        springAnimation.mass = 9.0
        springAnimation.damping = 0.0
        springAnimation.stiffness = 180.0
        
        return springAnimation
    }
    
    
    var transAction: CABasicAnimation {
        let trans = CABasicAnimation(keyPath: "transform.rotation")
        trans.duration = 0.2
        trans.fromValue = 0.0
        trans.toValue = Double.pi * 1.0
        trans.speed = 1.0
        
        return trans
    }
    
    
    func actionNodeGen() -> CABasicAnimation {
        let random = Int( arc4random_uniform(2) )
        switch random {
        case 0:
            return springAction
        case 1:
            return transAction
        default:
            return springAction
        }
    }
}
