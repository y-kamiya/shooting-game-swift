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

class TestScene:SKScene {
    
    let player = SKShapeNode(circleOfRadius: 10)
    
    override func didMove(to view: SKView) {
        
        player.fillColor = SKColor.black
        player.position = CGPoint(x: view.frame.width / 2, y: 50)
        self.addChild(player)
        
        let enemy = SKSpriteNode(imageNamed: "monster")
        enemy.position = CGPoint(x: 200, y: 500)
        self.addChild(enemy)
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
        self.addChild(shot)
        
        let distPos = CGPoint(x: shot.position.x, y: shot.position.y + 1000)
        shot.run(SKAction.sequence([
            SKAction.move(to: distPos, duration: 2.0)
          , SKAction.removeFromParent()
        ]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        touchBeganPosition = touch.location(in: self.view)
        touchBeganMark = SKShapeNode(circleOfRadius: 10)
        touchBeganMark?.fillColor = SKColor.red
        touchBeganMark?.position = convertPoint(fromView: touchBeganPosition!)
        self.addChild(touchBeganMark!)
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
            touchMovedMark = SKShapeNode(circleOfRadius: 5)
            touchMovedMark?.fillColor = SKColor.blue
            touchMovedMark?.position = convertPoint(fromView: touchMovedPosition!)
            self.addChild(touchMovedMark!)
            return
        }
        mark.position = convertPoint(fromView: touchMovedPosition!)
    }
    
    private func movePlayer(_ beganPos: CGPoint, _ movedPos: CGPoint) {
        let direction = (convertPoint(fromView: movedPos) - convertPoint(fromView: beganPos)).normalized()
        let distPos = player.position + direction * 10
        player.run(SKAction.move(to: distPos, duration: 0.1))
        print(direction)
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let beganPos = touchBeganPosition else {
            return;
        }
        guard let movedPos = touchMovedPosition else {
            return;
        }
        movePlayer(beganPos, movedPos)
        print(beganPos, movedPos);
    }
}
