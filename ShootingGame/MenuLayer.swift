//
//  MenuLayer.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/05/28.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class MenuLayer: SKNode {
    
    let menuButton = SKShapeNode(circleOfRadius: 50)
    convenience init(with size: CGSize) {
        self.init()
        self.initialize(size)
    }
    
    var scoreLabel: SKLabelNode?
    
    func initialize(_ size: CGSize) {
        scoreLabel = createScoreLabel()
        self.addChild(scoreLabel!)
        
        menuButton.position = CGPoint(x: size.width, y: 0)
        menuButton.fillColor = SKColor.gray
        self.addChild(menuButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateScore), name: Notification.Name("enemyDeadByBullet"), object: nil)
    }
    
    private func createScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode(text: "0")
        scoreLabel.position = CGPoint(x: 10, y: 10)
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = SKColor.black
        scoreLabel.horizontalAlignmentMode = .left
        return scoreLabel
    }
    
    @objc func updateScore() {
        guard let currentScore = Int(scoreLabel!.text!) else {
            return
        }
        scoreLabel!.text = String(currentScore + 100)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self.scene!)
            if (menuButton.contains(location)) {
//                self.scene?.view?.isPaused = true
                let transition = SKTransition.fade(withDuration: 2.0)
                let scene = TestScene(size: (self.scene?.view?.frame.size)!)
                self.scene?.view?.presentScene(scene, transition: transition)
            }
        }
    }
}
