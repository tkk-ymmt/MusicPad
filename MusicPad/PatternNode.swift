//
//  PatternNode.swift
//  MusicPad
//
//  Created by motoki on 2017/09/15.
//  Copyright © 2017年 motoki. All rights reserved.
//

import Foundation
import UIKit

protocol PatternNode {
    func single(tag: Int) -> [Int]
    func cross(tag: Int) -> [Int]
    func verticalLine(tag: Int) -> [Int]
    func horizontalLine(tag: Int) -> [Int]
    func launch(tag: Int) -> [Int]
    func box(tag: Int) -> [Int]
    func random(tag: Int) -> [Int]
    
    func patternNodeGen(tag: Int) -> [Int]
}



extension PatternNode {
    var nPattern: UInt32 {
        return 7
    }
    
    func patternNodeGen(tag: Int) -> [Int]  {
        let patternNumber = Int(arc4random_uniform(nPattern))
        var pattern: [Int] = []
        
        switch patternNumber {
        case 0:
            pattern = single(tag: tag)
            return pattern

        case 1:
            pattern = cross(tag: tag)
            return pattern

        case 2:
            pattern = verticalLine(tag: tag)
            return pattern
            
        case 3:
            pattern = horizontalLine(tag: tag)
            return pattern
            
        case 4:
            pattern = launch(tag: tag)
            return pattern
       
        case 5:
            pattern = box(tag: tag)
            return pattern
        
        case 6:
            pattern = random(tag: tag)
            return pattern

        default:
            pattern = single(tag: tag)
            return pattern
        }
    }
    
    
    func random(tag: Int) -> [Int] {
        var pattern: [Int] = [tag]
        for _ in 0 ..< 10 {
            var random = Int(arc4random_uniform(Numbers.nButton))
            while pattern.contains(random) {// 重複を防ぐ
                random = Int(arc4random_uniform(Numbers.nButton))
            }
            pattern.append( random )
        }
        return pattern
    }
    
    
    func single(tag: Int) -> [Int] {
        return [tag]
    }
    
    
    func cross(tag: Int) -> [Int] {
        print("tag:\(tag), animationPatternDistributer start")
        let place = Coordinates.place(tag: tag)
        
        switch place {
        case .bottomLeft:
            let tagNumberArray = [ tag,
                                   tag+1,
                                   tag+Numbers.nColumn ]
            return tagNumberArray
            
        case .upperLeft:
            let tagNumberArray = [ tag,
                                   tag+1,
                                   tag-Numbers.nColumn ]
            return tagNumberArray
            
        case .bottomRight:
            let tagNumberArray = [ tag,
                                   tag-1,
                                   tag+Numbers.nColumn ]
            return tagNumberArray
            
        case .upperRight:
            let tagNumberArray = [ tag,
                                   tag-1,
                                   tag-Numbers.nColumn ]
            return tagNumberArray
            
        case .left:
            let tagNumberArray = [ tag,
                                   tag+Numbers.nColumn,
                                   tag+1,
                                   tag-Numbers.nColumn ]
            return tagNumberArray
            
        case .right:
            let tagNumberArray = [ tag,
                                   tag+Numbers.nColumn,
                                   tag-1,
                                   tag-Numbers.nColumn ]
            return tagNumberArray
            
        case .bottom:
            let tagNumberArray = [ tag,
                                   tag-1,
                                   tag+Numbers.nColumn,
                                   tag+1 ]
            return tagNumberArray
            
        case .upper:
            let tagNumberArray = [ tag,
                                   tag+1,
                                   tag-Numbers.nColumn,
                                   tag-1 ]
            return tagNumberArray
            
        case .inside:
            let tagNumberArray = [ tag,
                                   tag+Numbers.nColumn,
                                   tag+1,
                                   tag-Numbers.nColumn,
                                   tag-1 ]
            return tagNumberArray
        }
    }
    
    
    func box(tag: Int) -> [Int] {
        let place = Coordinates.place(tag: tag)
        
        switch place {
        case .bottomLeft:
            let tagNumberArray = [ tag,
                                   tag+Numbers.nColumn,
                                   tag+Numbers.nColumn+1,
                                   tag+1]
            return tagNumberArray
            
        case .upperLeft:
            let tagNumberArray = [ tag,
                                   tag+1,
                                   tag-(Numbers.nColumn-1),
                                   tag-Numbers.nColumn]
            return tagNumberArray
            
        case .bottomRight:
            let tagNumberArray = [ tag,
                                   tag-1,
                                   tag+(Numbers.nColumn-1),
                                   tag+Numbers.nColumn ]
            return tagNumberArray
            
        case .upperRight:
            let tagNumberArray = [ tag,
                                   tag-1,
                                   tag-(Numbers.nColumn-1),
                                   tag-Numbers.nColumn]
            return tagNumberArray
            
        case .left:
            let tagNumberArray = [ tag,
                                   tag+Numbers.nColumn,
                                   tag+(Numbers.nColumn+1),
                                   tag+1,
                                   tag-(Numbers.nColumn-1),
                                   tag-Numbers.nColumn]
            return tagNumberArray
            
        case .right:
            let tagNumberArray = [ tag,
                                   tag-Numbers.nColumn,
                                   tag-(Numbers.nColumn+1),
                                   tag-1,
                                   tag+(Numbers.nColumn-1),
                                   tag+Numbers.nColumn]
            return tagNumberArray
            
        case .bottom:
            let tagNumberArray = [ tag,
                                   tag-1,
                                   tag+(Numbers.nColumn-1),
                                   tag+Numbers.nColumn,
                                   tag+(Numbers.nColumn*1),
                                   tag+1]
            return tagNumberArray
            
        case .upper:
            let tagNumberArray = [ tag,
                                   tag+1,
                                   tag-(Numbers.nColumn-1),
                                   tag-Numbers.nColumn,
                                   tag-(Numbers.nColumn+1),
                                   tag-1 ]
            return tagNumberArray
            
        case .inside:
            let tagNumberArray = [ tag,
                                   tag+Numbers.nColumn,
                                   tag+(Numbers.nColumn+1),
                                   tag+1,
                                   tag-(Numbers.nColumn-1),
                                   tag-Numbers.nColumn,
                                   tag-(Numbers.nColumn+1),
                                   tag-1,
                                   tag+(Numbers.nColumn-1)]
            return tagNumberArray
        }
    }
    
    
    func verticalLine(tag: Int) -> [Int] {
        let coordinate = tag % 4
        var tagNumberArray: [Int] = []
        for i in 0 ..< Numbers.maxTag/Numbers.nColumn {
            tagNumberArray.append( coordinate + i * Numbers.nColumn )
        }
        
        return tagNumberArray
        
    }
    
    
    func horizontalLine(tag: Int) -> [Int] {
        let coordinate = tag / Numbers.nColumn
        var tagNumberArray: [Int] = []
        for i in 0 ..< Numbers.nColumn {
            tagNumberArray.append( coordinate * Numbers.nColumn + i )
        }
        
        return tagNumberArray
    }
    
    
    func launch(tag: Int) -> [Int] {
        var tagNumberArray: [Int] = []
        let x = tag % Numbers.nColumn
        let y = tag / Numbers.nColumn
        for i in y ..< Numbers.maxTag/Numbers.nColumn {
            tagNumberArray.append( x + i * Numbers.nColumn )
        }

        return tagNumberArray
    }
    
    
}
