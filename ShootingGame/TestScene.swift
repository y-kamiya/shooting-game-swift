//
//  TestScene.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/04/16.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class TestScene:SKScene {
    
    let playerController = PlayerController()
    var shootingLayer: ShootingLayer?
    var menuLayer: MenuLayer?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        self.scaleMode = .aspectFill
        
        self.addChild(playerController)
        
        shootingLayer = ShootingLayer(with: view.frame.size)
        self.addChild(shootingLayer!)
        
        menuLayer = MenuLayer(with: view.frame.size)
        self.addChild(menuLayer!)
        
        self.physicsWorld.contactDelegate = shootingLayer
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerController.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerController.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerController.touchesEnded(touches, with: event)
        menuLayer?.touchesEnded(touches, with: event)
    }
    
    private var elapsedSeconds: TimeInterval = 0
    private var lastUpdatedTime: TimeInterval = 0
    
    private let ENEMY_CREATED_INTERVAL: TimeInterval = 1.5
    
    override func update(_ currentTime: TimeInterval) {
        elapsedSeconds += currentTime - lastUpdatedTime
        if (ENEMY_CREATED_INTERVAL < elapsedSeconds) {
            elapsedSeconds = 0
            shootingLayer?.createEnemy()
        }
        lastUpdatedTime = currentTime
        
        guard let beganPos = playerController.getTouchBeganPosition() else {
            return;
        }
        guard let movedPos = playerController.getTouchMovedPosition() else {
            return;
        }
        let direction = self.getUnitVecor(start: beganPos, end: movedPos)
        shootingLayer?.movePlayer(direction: direction)
    }
    
    private func getUnitVecor(start: CGPoint, end: CGPoint) -> CGPoint {
        let startP = convertPoint(fromView: start)
        let endP = convertPoint(fromView: end)
        return (endP - startP).normalized()
    }
    
}
