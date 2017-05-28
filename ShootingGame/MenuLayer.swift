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
    
    convenience init(with size: CGSize) {
        self.init()
        self.initialize(size)
    }
    
    var scoreLabel: SKLabelNode?
    
    func initialize(_ size: CGSize) {
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel!.position = CGPoint(x: 10, y: 10)
        scoreLabel!.fontSize = 36
        scoreLabel!.fontColor = SKColor.black
        scoreLabel!.horizontalAlignmentMode = .left
        self.addChild(scoreLabel!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateScore), name: Notification.Name("enemyDeadByBullet"), object: nil)
    }
    
    @objc func updateScore() {
        guard let currentScore = Int(scoreLabel!.text!) else {
            return
        }
        scoreLabel!.text = String(currentScore + 100)
    }
}
