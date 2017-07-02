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
    
    let buttonMenu = SKShapeNode(circleOfRadius: 50)
    let buttonSpeedup = SKShapeNode(rect: CGRect(x:20, y:50, width: 30, height: 30))
    let buttonUpgradeShot = SKShapeNode(rect: CGRect(x:20, y:100, width: 30, height: 30))
    let buttonAddOption = SKShapeNode(rect: CGRect(x:20, y:150, width: 30, height: 30))
    
    convenience init(with size: CGSize) {
        self.init()
        self.initialize(size)
    }
    
    var scoreLabel: SKLabelNode?
    
    func initialize(_ size: CGSize) {
        scoreLabel = createScoreLabel()
        self.addChild(scoreLabel!)
        
        buttonMenu.position = CGPoint(x: size.width, y: 0)
        buttonMenu.fillColor = SKColor.gray
        self.addChild(buttonMenu)
        buttonSpeedup.fillColor = SKColor.gray
        self.addChild(buttonSpeedup)
        buttonUpgradeShot.fillColor = SKColor.gray
        self.addChild(buttonUpgradeShot)
        buttonAddOption.fillColor = SKColor.gray
        self.addChild(buttonAddOption)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateScore), name: Event.enemyDead.name, object: nil)
    }
    
    private func createScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode(text: "0")
        scoreLabel.position = CGPoint(x: 10, y: 10)
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = SKColor.white
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
            if (buttonMenu.contains(location)) {
                let scene = self.scene as! TestScene
                scene.restart()
            }
            if (buttonSpeedup.contains(location)) {
                print("speedup button")
                NotificationCenter.default.post(name: Event.speedup.name, object: nil)
            }
            if (buttonUpgradeShot.contains(location)) {
                NotificationCenter.default.post(name: Event.upgradeShot.name, object: nil)
            }
            if (buttonAddOption.contains(location)) {
                NotificationCenter.default.post(name: Event.addOption.name, object: nil)
            }
        }
    }
}
