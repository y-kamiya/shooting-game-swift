//
//  PlayerController.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/05/27.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerController : SKNode {
    
    private var touchBeganMark: SKShapeNode?
    private var touchMovedMark: SKShapeNode?
    private var touchBeganPosition: CGPoint?
    private var touchMovedPosition: CGPoint?
    
    func getTouchBeganPosition() -> CGPoint? {
        return touchBeganPosition
    }
    
    func getTouchMovedPosition() -> CGPoint? {
        return touchMovedPosition
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        touchBeganPosition = touch.location(in: self.scene!.view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touchBeganPosition else {
            return
        }
        guard let touch = touches.first else {
            return
        }
        touchMovedPosition = touch.location(in: self.scene!.view)
        
        guard let mark = touchMovedMark else {
            touchMovedMark = SKShapeNode(circleOfRadius: 20)
            touchMovedMark?.fillColor = SKColor.blue
            touchMovedMark?.position = self.scene!.convertPoint(fromView: touchMovedPosition!)
            self.addChild(touchMovedMark!)
            return
        }
        mark.position = self.scene!.convertPoint(fromView: touchMovedPosition!)
        
        if (touchBeganMark == nil) {
            touchBeganMark = SKShapeNode(circleOfRadius: 10)
            touchBeganMark?.fillColor = SKColor.red
            touchBeganMark?.position = self.scene!.convertPoint(fromView: touchBeganPosition!)
            self.addChild(touchBeganMark!)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touchBeganPosition else {
            return
        }
        guard let _ = touchMovedPosition else {
            touchBeganPosition = nil;
            NotificationCenter.default.post(name: Event.shot.name, object: nil)
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
}
