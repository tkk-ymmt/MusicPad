//
//  Numbers.swift
//  MusicPad
//
//  Created by motoki on 2017/11/01.
//  Copyright © 2017年 motoki. All rights reserved.
//

import Foundation

enum Numbers {
    static let nColumn: Int = 4
    static let nRow: Int = 7
    static var maxTag: Int {
        return Int(nButton) - 1
    }
    static var nButton: UInt32 {
        return UInt32(nColumn * nRow)
    }
}
