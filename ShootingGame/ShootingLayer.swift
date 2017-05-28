//
//  ShootingLayer.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/05/28.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class ShootingLayer: SKNode, SKPhysicsContactDelegate {
    
    enum NodeName: String {
        case player = "player"
        case wall = "wall"
    }
    
    let player = Player()
    
    convenience init(with size: CGSize) {
        self.init()
        self.initialize(size)
    }
    
    func initialize(_ size: CGSize) {
        let frameWidth = size.width
        let frameHeight = size.height
        
        player.position = CGPoint(x: frameWidth / 2, y: 50)
        player.name = NodeName.player.rawValue
        self.addChild(player)
        
        let origin = CGPoint(x:-50, y:-50)
        let size = CGSize(width: frameWidth + 100, height: frameHeight + 100)
        let wall = SKShapeNode(rect: CGRect(origin: origin, size: size))
        wall.physicsBody = SKPhysicsBody(edgeChainFrom: wall.path!)
        wall.physicsBody?.categoryBitMask = ContactCategory.wall
        wall.physicsBody?.collisionBitMask = ContactCategory.none
        wall.physicsBody?.contactTestBitMask = ContactCategory.all
        wall.name = NodeName.wall.rawValue
        self.addChild(wall)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shot), name: Notification.Name("shot"), object: nil)
        
    }
    
    @objc private func shot() {
        guard let player = childNode(withName: NodeName.player.rawValue) else {
            return;
        }
        let shot = Bullet(position: player.position)
        self.addChild(shot)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
            return
        }
        
        if (contact.bodyA.categoryBitMask != ContactCategory.wall) {
            contact.bodyA.node?.removeFromParent();
        }
        if (contact.bodyB.categoryBitMask != ContactCategory.wall) {
            contact.bodyB.node?.removeFromParent();
        }
        let bitmask = contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask
        let targetBistmask = ContactCategory.bullet + ContactCategory.enemy
        if (bitmask == targetBistmask) {
            let name = Notification.Name("enemyDeadByBullet")
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
    
    func movePlayer(direction: CGPoint) {
        guard let player = childNode(withName: NodeName.player.rawValue) as? Player else {
            return;
        }
        player.move(for: direction)
    }
    
    func createEnemy() {
        let enemy = Enemy(frame: self.scene!.view!.frame)
        self.addChild(enemy)
    }
}
