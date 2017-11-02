//
//  ScaleButtonView.swift
//  MusicPad
//
//  Created by motoki on 2017/09/01.
//  Copyright © 2017年 motoki. All rights reserved.
//

import Foundation
import UIKit

class ScaleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.buttonInit()
    }
    
    fileprivate func buttonInit() {
        layer.backgroundColor =  Colors.panelDefault
        self.setTitle("", for: UIControlState.normal)
    }
    
        
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet  {
            layer.cornerRadius = cornerRadius
        }
    }    
}
