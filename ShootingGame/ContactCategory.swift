//
//  ContactCategory.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/05/23.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation

enum ContactCategory {
    static let none  :UInt32 = 0
    static let player:UInt32 = 1 << 0
    static let enemy :UInt32 = 1 << 1
    static let bullet:UInt32 = 1 << 2
    static let wall  :UInt32 = 1 << 3
    static let item  :UInt32 = 1 << 4
    static let option:UInt32 = 1 << 5
    static let all   :UInt32 = 1 << 31 - 1
}

enum Event: String {
    case shot        = "shot"
    case playerDead  = "playerDead"
    case enemyDead   = "enemyDead"
    case speedup     = "speedup"
    case upgradeShot = "upgradeShot"
    case addOption   = "addOption"
    
    var name: Notification.Name {
        return Notification.Name(self.rawValue)
    }
}
    
