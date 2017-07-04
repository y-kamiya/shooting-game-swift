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
        let vecter = CGVector(dx: direction.x * vel, dy: direction.y * vel)
        run(SKAction.move(by: vecter, duration: 0.001))
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
    
    private func useItem() -> Bool {
        if (0 < itemOwned) {
            itemOwned -= 1
            return true;
        }
        return false
    }
    
    public func speedup() {
        let isUsed = useItem()
        if (isUsed) {
            velocity += 2
            print("speedup success")
        }
    }
    
    public func upgradeShot() {
        let type = ShotType(rawValue: currentShotType.rawValue + 1)
        guard let nextType = type else {
            return
        }
        currentShotType = nextType
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
