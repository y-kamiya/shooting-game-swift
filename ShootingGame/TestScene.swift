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
    
    let playerController = PlayerController()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        self.addChild(playerController)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerController.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerController.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerController.touchesEnded(touches, with: event)
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
    
    private var elapsedSeconds: TimeInterval = 0
    private var lastUpdatedTime: TimeInterval = 0
    
    private let ENEMY_CREATED_INTERVAL: TimeInterval = 1.5
    
    override func update(_ currentTime: TimeInterval) {
        elapsedSeconds += currentTime - lastUpdatedTime
        if (ENEMY_CREATED_INTERVAL < elapsedSeconds) {
            elapsedSeconds = 0
            let enemy = Enemy(frame: (view?.frame)!)
            self.addChild(enemy)
        }
        lastUpdatedTime = currentTime
        
        guard let beganPos = playerController.getTouchBeganPosition() else {
            return;
        }
        guard let movedPos = playerController.getTouchMovedPosition() else {
            return;
        }
        
        guard let player = childNode(withName: NodeName.player.rawValue) as? Player else {
            return;
        }
        let direction = self.getUnitVecor(start: beganPos, end: movedPos)
        player.move(for: direction)
    }
    
    private func getUnitVecor(start: CGPoint, end: CGPoint) -> CGPoint {
        let startP = convertPoint(fromView: start)
        let endP = convertPoint(fromView: end)
        return (endP - startP).normalized()
    }
    
}
