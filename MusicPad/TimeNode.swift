//
//  TimeNode.swift
//  MusicPad
//
//  Created by motoki on 2017/11/01.
//  Copyright © 2017年 motoki. All rights reserved.
//

import Foundation

protocol TimeNode {
    func timeNodeGen() -> Bool
}

extension TimeNode {
    func timeNodeGen() -> Bool {
        let random = Int( arc4random_uniform(2) )
        switch random {
        case 0:
            return true
        case 1:
            return false
        default:
            return true
        }
    }
}


