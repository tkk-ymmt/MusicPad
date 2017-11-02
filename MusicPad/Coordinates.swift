//
//  Coordinates.swift
//  MusicPad
//
//  Created by motoki on 2017/11/02.
//  Copyright © 2017年 motoki. All rights reserved.
//

import Foundation
enum Coordinates {
    
    // place of button
    case upperLeft
    case upperRight
    case bottomLeft
    case bottomRight
    case upper
    case bottom
    case left
    case right
    case inside
    
    static func place(tag: Int) -> Coordinates {
        let coordinates = (tag % Numbers.nColumn , tag / Numbers.nColumn)
        switch coordinates {
        case (0, 0)://左下
            return .bottomLeft
            
        case (0, Numbers.maxTag/Numbers.nColumn)://左上
            return .upperLeft
            
        case (Numbers.nColumn-1, 0)://右下
            return .bottomRight
            
        case (Numbers.nColumn-1, Numbers.maxTag/Numbers.nColumn)://右上
            return .upperRight
            
        case (let x, let y) where x == 0 && 1 <= y && y <= Numbers.nRow-2 ://左側
            return .left
            
        case (let x, let y) where x == Numbers.nColumn-1 && 1 <= y && y <= Numbers.nRow-2 ://右側
            return .right
            
        case (let x, let y) where 1 <= x && x <= Numbers.nColumn-2 && y == 0 ://下側
            return .bottom
            
        case (let x, let y) where 1 <= x && x <= Numbers.nColumn-2 && y == Numbers.maxTag / Numbers.nColumn://上側
            return .upper
            
        default://内側
            return .inside
        }
    }
}
