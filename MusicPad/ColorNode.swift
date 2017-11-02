//
//  ColorNode.swift
//  MusicPad
//
//  Created by motoki on 2017/09/15.
//  Copyright © 2017年 motoki. All rights reserved.
//

import Foundation
import UIKit

protocol ColorNode {
    func colorNodeGen() -> CABasicAnimation
}

extension ColorNode {
    func colorNodeGen() -> CABasicAnimation {
        let colorNode = CABasicAnimation(keyPath: "backgroundColor")
        colorNode.duration = 0.2
        colorNode.autoreverses = true
        colorNode.fromValue = Colors.panelDefault
        colorNode.toValue = Colors.choiceColor()
        return colorNode
    }
}









