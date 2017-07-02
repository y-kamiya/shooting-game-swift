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
    
    let player = Player()
    
    convenience init(with size: CGSize) {
        self.init()
        self.initialize(size)
    }
    
    func initialize(_ size: CGSize) {
        let frameWidth = size.width
        let frameHeight = size.height
        
        player.position = CGPoint(x: frameWidth / 2, y: 50)
        self.addChild(player)
        
        createItem(position: CGPoint(x:100, y:100))
        
        let origin = CGPoint(x:-50, y:-50)
        let size = CGSize(width: frameWidth + 100, height: frameHeight + 100)
        let field = Field(rect: CGRect(origin: origin, size: size))
        field.setPhysicsBody()
        self.addChild(field)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shot), name: Event.shot.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDead), name: Event.playerDead.name, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.enemyDead), name: Event.enemyDead.name, object: nil)
        
    }
    
    @objc private func shot() {
        let bullets = player.shot()
        bullets.forEach({ bullet in self.addChild(bullet) })
    }
    
    @objc private func playerDead() {
        let scene = self.scene as! TestScene
        scene.view?.isPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            scene.view?.isPaused = false
            scene.restart()
        })
        
        guard let size = scene.view?.frame.size else {
            return
        }
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.verticalAlignmentMode = .center
        addChild(gameOverLabel)
    }
    
    @objc private func enemyDead(notification: Notification) {
        guard let position = notification.object as? CGPoint else {
            return
        }
        createItem(position: position)
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
    
    func createItem(position: CGPoint) {
        let item = Item(position: position)
        item.position = position
        self.addChild(item)
    }
}
