//
//  Player.swift
//  ShootingGame
//
//  Created by Yuji Kamiya on 2017/05/23.
//  Copyright © 2017年 uj. All rights reserved.
//

import Foundation
import SpriteKit

class Player: Unit {
    
    var options: [PlayerOption] = []
    var moveHistory: [CGVector] = []
    
    enum ShotType: Int {
        case Default
        case Double
        case ThreeWay
    }
    
    var velocity: Float = 3
    var itemOwned: Int = 0
    var currentShotType = ShotType.Default
    
    convenience init() {
        self.init(imageNamed: "player")
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.physicsBody?.categoryBitMask = ContactCategory.player
        self.physicsBody?.contactTestBitMask = ContactCategory.wall + ContactCategory.enemy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func move(for direction: CGPoint) {
        let vel = CGFloat(velocity)
        let vector = CGVector(dx: direction.x * vel, dy: direction.y * vel)
        run(SKAction.move(by: vector, duration: 0.001))
        
        if (options.count == 0) {
            return
        }
        if (200 < moveHistory.count) {
            moveHistory = moveHistory.suffix(options.count * 20).map { $0 }
            print("history is sliced")
        }
        moveHistory.append(vector)
        let historyCount = moveHistory.count
        for id in (1 ..< options.count + 1) {
            let index = historyCount - id * 20
            if (index < 0) {
                continue
            }
            let vector = moveHistory[index]
            let option = options[id - 1]
            option.move(for: vector)
        }
    }
    
    public func shot() -> [Bullet] {
        return createBullets()
    }
    
    private func createBullets() -> [Bullet] {
        print(position)
        switch currentShotType {
        case .Default: return [Bullet(from: position)]
        case .Double: return [
            Bullet(from: CGPoint(x: position.x - 10, y: position.y)),
            Bullet(from: CGPoint(x: position.x + 10, y: position.y))]
        case .ThreeWay: return [
            BulletSkewRight(from: position),
            Bullet(from: CGPoint(x: position.x - 10, y: position.y)),
            Bullet(from: CGPoint(x: position.x + 10, y: position.y)),
            BulletSkewLeft(from: position)]
        }
    }
    
    private func getItem() {
        itemOwned += 1
    }
    
    private func useItem(num: Int) -> Bool {
        if (0 < itemOwned) {
            itemOwned -= 1
            return true;
        }
        return false
    }
    
    public func speedup() {
        let isUsed = useItem(num: Item.NumRequired.speedup)
        if (isUsed) {
            velocity += 2
            print("speedup success")
        }
    }
    
    public func upgradeShot() {
        let isUsed = useItem(num: Item.NumRequired.upgradeShot)
        if (!isUsed) {
            return
        }
        let type = ShotType(rawValue: currentShotType.rawValue + 1)
        guard let nextType = type else {
            return
        }
        currentShotType = nextType
    }
    
    public func addOption() -> PlayerOption {
        let option = PlayerOption(position: position)
        options.append(option)
        return option
    }
    
    override func collide(with bitmask: UInt32) {
        if (bitmask == ContactCategory.item) {
            print("getItem")
            return getItem()
        }
        removeFromParent()
        NotificationCenter.default.post(name: Event.playerDead.name, object: nil)
    }
}
