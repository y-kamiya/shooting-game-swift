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
        let field = Field(rect: CGRect(origin: origin, size: size))
        field.setPhysicsBody()
        self.addChild(field)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shot), name: Notification.Name("shot"), object: nil)
        
    }
    
    @objc private func shot() {
        let bullets = player.shot()
        bullets.forEach({ bullet in self.addChild(bullet) })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? Collidable else {
            return
        }
        guard let nodeB = contact.bodyB.node as? Collidable else {
            return
        }
        nodeA.collide(with: contact.bodyB.categoryBitMask);
        nodeB.collide(with: contact.bodyA.categoryBitMask);
    }
    
    func movePlayer(direction: CGPoint) {
        player.move(for: direction)
    }
    
    func createEnemy() {
        let enemy = Enemy(frame: self.scene!.view!.frame)
        self.addChild(enemy)
    }
}
