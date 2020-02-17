/*
 File Name: CoinBag.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit

// The CoinBag Class
class CoinBag: GameObject
{
    var location: CGPoint?
    var target: CGPoint?
    //constructor
    init(spawnLocation: CGPoint, targetLocation: CGPoint)
    {
        super.init(imageString: "coinBag", initialScale: 0.2)
        location = spawnLocation
        target = targetLocation
        Start()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Move()
    {
        
    }
    
    // Fly towards the target location
    override func Start()
    {
        self.position = location!
        self.zPosition = 30
        let offset = CGPoint(x: target!.x - self.position.x, y: target!.y - self.position.y)
        let distance = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let duration = 0.02 * distance / 10
        let move = SKAction.move(to: target!, duration: duration)
        self.run(move)
        self.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 4),
                SKAction.removeFromParent()
                ])
        )
    }
    
    override func Update()
    {
        
    }
}
