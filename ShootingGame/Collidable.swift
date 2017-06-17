//
//  Collidable.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/06/17.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

protocol Collidable {
    func collide(with: UInt32)
}
