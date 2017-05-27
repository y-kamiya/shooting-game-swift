//
//  TestScene.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/04/16.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class TestScene:SKScene, SKPhysicsContactDelegate {
    
    enum NodeName: String {
        case player = "player"
        case wall = "wall"
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        let frameWidth = view.frame.width 
        let frameHeight = view.frame.height
        
        let player = Player()
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
        self.addChild(wall)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shot), name: Notification.Name("shot"), object: nil)
        
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
            let name = Notification.Name("shot")
            NotificationCenter.default.post(name: name, object: nil)
//            shot()
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
    
    @objc private func shot() {
        guard let player = childNode(withName: NodeName.player.rawValue) else {
            return;
        }
        let shot = Bullet(position: player.position)
        self.addChild(shot)
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
        
        guard let player = childNode(withName: NodeName.player.rawValue) as? Player else {
            return;
        }
        let direction = self.getUnitVecor(start: beganPos, end: movedPos)
        player.move(for: direction)
    }
    
    func createEnemy(position: CGPoint) -> SKNode {
        let enemy = Enemy(imageNamed: "monster")
        enemy.position = position
        return enemy
    }
    
    private func getUnitVecor(start: CGPoint, end: CGPoint) -> CGPoint {
        let startP = convertPoint(fromView: start)
        let endP = convertPoint(fromView: end)
        return (endP - startP).normalized()
    }
    
}
