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
        
        let item = Item()
        item.position = CGPoint(x:100, y:100)
        addChild(item)
        
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
        let bullets = player.shot()
        bullets.forEach({ bullet in self.addChild(bullet) })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
            return
        }
        
        let bitmask = contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask
        let playerItem = ContactCategory.player + ContactCategory.item
        if (bitmask == playerItem) {
            var p : Player
            var i : Item
            if (contact.bodyA.categoryBitMask == ContactCategory.player) {
                p = contact.bodyA.node as! Player
                i = contact.bodyB.node as! Item
            } else {
                p = contact.bodyB.node as! Player
                i = contact.bodyA.node as! Item
            }
            p.getItem()
            i.removeFromParent()
            return
        }
        
        if (contact.bodyA.categoryBitMask != ContactCategory.wall) {
            contact.bodyA.node?.removeFromParent();
        }
        if (contact.bodyB.categoryBitMask != ContactCategory.wall) {
            contact.bodyB.node?.removeFromParent();
        }
        
        let bulletEnemy = ContactCategory.bullet + ContactCategory.enemy
        if (bitmask == bulletEnemy) {
            let name = Notification.Name("enemyDeadByBullet")
            NotificationCenter.default.post(name: name, object: nil)
            return
        }
    }
    
    func movePlayer(direction: CGPoint) {
        player.move(for: direction)
    }
    
    func createEnemy() {
        let enemy = Enemy(frame: self.scene!.view!.frame)
        self.addChild(enemy)
    }
}
