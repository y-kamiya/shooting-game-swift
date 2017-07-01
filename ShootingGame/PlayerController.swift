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
    
    private var touchBeganMark: SKShapeNode
    private var touchMovedMark: SKShapeNode
    private var touchBeganPosition: CGPoint? = nil
    private var touchMovedPosition: CGPoint? = nil
    
    override init() {
        touchMovedMark = SKShapeNode(circleOfRadius: 20)
        touchMovedMark.fillColor = SKColor.blue
        touchBeganMark = SKShapeNode(circleOfRadius: 10)
        touchBeganMark.fillColor = SKColor.red
        
        super.init()
        
        addChild(touchMovedMark)
        addChild(touchBeganMark)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        touchBeganMark.position = self.scene!.convertPoint(fromView: touchBeganPosition!)
        touchMovedMark.position = self.scene!.convertPoint(fromView: touchMovedPosition!) 
        touchBeganMark.isHidden = false
        touchMovedMark.isHidden = false
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
        
        touchBeganMark.isHidden = true
        touchMovedMark.isHidden = true
    }
}
