//
//  TestScene.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/04/16.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class TestScene:SKScene, SKPhysicsContactDelegate {
    
    let player = SKShapeNode(circleOfRadius: 10)
    
    enum ContactCategory {
        static let none  :UInt32 = 0
        static let player:UInt32 = 1 << 0
        static let enemy :UInt32 = 1 << 1
        static let bullet:UInt32 = 1 << 2
        static let wall  :UInt32 = 1 << 3
        static let all   :UInt32 = 1 << 31 - 1
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        let frameWidth = view.frame.width 
        let frameHeight = view.frame.height
        
        player.fillColor = SKColor.black
        player.position = CGPoint(x: frameWidth / 2, y: 50)
        player.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        player.physicsBody?.categoryBitMask = ContactCategory.player
        player.physicsBody?.collisionBitMask = ContactCategory.wall + ContactCategory.enemy
        player.physicsBody?.contactTestBitMask = ContactCategory.all
        self.addChild(player)
        
        
        let origin = CGPoint(x:-10, y:100)
        let size = CGSize(width: frameWidth + 20, height: frameHeight + 20)
        let wall = SKShapeNode(rect: CGRect(origin: origin, size: size))
        wall.physicsBody = SKPhysicsBody(edgeChainFrom: wall.path!)
        wall.physicsBody?.categoryBitMask = ContactCategory.wall
        wall.physicsBody?.collisionBitMask = ContactCategory.none
        wall.physicsBody?.contactTestBitMask = ContactCategory.all
        wall.fillColor = SKColor.brown
        self.addChild(wall)
    }
    
    private var touchBeganMark: SKShapeNode?
    private var touchMovedMark: SKShapeNode?
    private var touchBeganPosition: CGPoint?
    private var touchMovedPosition: CGPoint?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touchBeganPosition else {
            return
        }
        guard let _ = touchMovedPosition else {
            touchBeganPosition = nil;
            shot()
            return
        }
        touchBeganPosition = nil;
        touchMovedPosition = nil;
        
        guard let beganMark = touchBeganMark else {
            return
        }
        self.removeChildren(in: [beganMark])
        touchBeganMark = nil;
        
        guard let movedMark = touchMovedMark else {
            return
        }
        self.removeChildren(in: [movedMark])
        touchMovedMark = nil;
    }
    
    private func shot() {
        let shot = SKSpriteNode(imageNamed: "projectile")
        shot.position = player.position
        shot.physicsBody = SKPhysicsBody(texture: shot.texture!, size: shot.texture!.size())
        shot.physicsBody?.categoryBitMask = ContactCategory.bullet
        shot.physicsBody?.collisionBitMask = ContactCategory.none
        self.addChild(shot)
        
        let distPos = CGPoint(x: shot.position.x, y: shot.position.y + 1000)
        shot.run(SKAction.sequence([
            SKAction.move(to: distPos, duration: 2.0)
          , SKAction.removeFromParent()
        ]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask != ContactCategory.wall) {
            contact.bodyA.node?.removeFromParent();
        }
        if (contact.bodyB.categoryBitMask != ContactCategory.wall) {
            contact.bodyB.node?.removeFromParent();
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        touchBeganPosition = touch.location(in: self.view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touchBeganPosition else {
            return
        }
        guard let touch = touches.first else {
            return
        }
        touchMovedPosition = touch.location(in: self.view)
        
        guard let mark = touchMovedMark else {
            touchMovedMark = SKShapeNode(circleOfRadius: 20)
            touchMovedMark?.fillColor = SKColor.blue
            touchMovedMark?.position = convertPoint(fromView: touchMovedPosition!)
            self.addChild(touchMovedMark!)
            return
        }
        mark.position = convertPoint(fromView: touchMovedPosition!)
        
        if (touchBeganMark == nil) {
            touchBeganMark = SKShapeNode(circleOfRadius: 10)
            touchBeganMark?.fillColor = SKColor.red
            touchBeganMark?.position = convertPoint(fromView: touchBeganPosition!)
            self.addChild(touchBeganMark!)
        }
        
    }
    
    private func movePlayer(_ beganPos: CGPoint, _ movedPos: CGPoint) {
        let direction = (convertPoint(fromView: movedPos) - convertPoint(fromView: beganPos)).normalized()
        let distPos = player.position + direction * 10
        player.run(SKAction.move(to: distPos, duration: 0.1))
    }
    
    private var elapsedSeconds: TimeInterval = 0
    private var lastUpdatedTime: TimeInterval = 0
    
    private let ENEMY_CREATED_INTERVAL: TimeInterval = 1.5
    private let ENEMY_SPEED_Y: Float = 100
    
    override func update(_ currentTime: TimeInterval) {
        elapsedSeconds += currentTime - lastUpdatedTime
        if (ENEMY_CREATED_INTERVAL < elapsedSeconds) {
            elapsedSeconds = 0
            let x = CGFloat(arc4random() % UInt32((view?.frame.width)!))
            let height = (view?.frame.height)!
            let position = CGPoint(x:x, y:height)
            let enemy = createEnemy(position: position)
            self.addChild(enemy)
            
            let duration = Float(height) / ENEMY_SPEED_Y
            enemy.run(SKAction.move(to: CGPoint(x:x, y:-100), duration: TimeInterval(duration)))
        }
        lastUpdatedTime = currentTime
        
        guard let beganPos = touchBeganPosition else {
            return;
        }
        guard let movedPos = touchMovedPosition else {
            return;
        }
        movePlayer(beganPos, movedPos)
    }
    
    func createEnemy(position: CGPoint) -> SKNode {
        let enemy = SKSpriteNode(imageNamed: "monster")
        enemy.position = position
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.texture!.size())
        enemy.physicsBody?.categoryBitMask = ContactCategory.enemy
        enemy.physicsBody?.collisionBitMask = ContactCategory.none
        enemy.physicsBody?.contactTestBitMask = ContactCategory.bullet
        return enemy
    }
    
}
