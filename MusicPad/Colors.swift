//
//  Colors.swift
//  MusicPad
//
//  Created by motoki on 2017/11/01.
//  Copyright © 2017年 motoki. All rights reserved.
//

import Foundation
import UIKit

enum Colors {
    static let panelDefault = UIColor(red: 255/255, green: 255/255, blue: 230/255, alpha: 1).cgColor
    
    static let usuasagi     = UIColor(red: 105/255, green: 188/255, blue: 182/255, alpha: 1).cgColor
    static let araishu      = UIColor(red: 221/255, green:  99/255, blue:  81/255, alpha: 1).cgColor
    static let tamagoiro    = UIColor(red: 241/255, green: 172/255, blue:  85/255, alpha: 1).cgColor
    static let byakuroku    = UIColor(red: 167/255, green: 211/255, blue: 180/255, alpha: 1).cgColor
    static let asagiiro     = UIColor(red:   0/255, green: 118/255, blue: 118/255, alpha: 1).cgColor
    static let kurimushiiro = UIColor(red: 241/255, green: 233/255, blue: 175/255, alpha: 1).cgColor
    static let koujiiro     = UIColor(red: 229/255, green: 129/255, blue:  35/255, alpha: 1).cgColor
    static let wakatakeiro  = UIColor(red:   0/255, green: 156/255, blue: 125/255, alpha: 1).cgColor
    static let koubaiiro    = UIColor(red: 218/255, green:  80/255, blue: 114/255, alpha: 1).cgColor
    static let kurenai      = UIColor(red: 169/255, green:  28/255, blue:  50/255, alpha: 1).cgColor
    
    static func choiceColor() -> CGColor {
        let random = Int( arc4random_uniform(10) )
        
        switch random {
        case 0:
            return Colors.usuasagi
            
        case 1:
            return Colors.araishu
            
        case 2:
            return Colors.tamagoiro
            
        case 3:
            return Colors.byakuroku
            
        case 4:
            return Colors.koujiiro
            
        case 5:
            return Colors.asagiiro
            
        case 6:
            return Colors.koujiiro
            
        case 7:
            return Colors.wakatakeiro
            
        case 8:
            return Colors.koubaiiro
            
        case 9:
            return Colors.kurenai
            
        default:
            return Colors.usuasagi
            
        }
    }
}
