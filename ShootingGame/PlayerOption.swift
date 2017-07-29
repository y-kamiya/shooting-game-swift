//
//  PlayerOption.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/07/09.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerOption: Unit {
    
    convenience init(position p: CGPoint) {
        self.init(imageNamed: "player")
        self.position = CGPoint(x: p.x, y: p.y)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody?.categoryBitMask = ContactCategory.option
        self.physicsBody?.contactTestBitMask = ContactCategory.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func move(for vector: CGVector) {
        run(SKAction.move(by: vector, duration: 0.001))
    }
}
