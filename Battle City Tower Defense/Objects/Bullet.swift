/*
 File Name: Bullet.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit

// The Enemy Bullet GameObject
class Bullet: GameObject
{
    
    var objectPosition: CGPoint?
    var targetPosition: CGPoint?
    var power: Int = 10
    
    //constructor
    init(positionX: CGFloat, positionY: CGFloat, target: CGPoint, damage: Int)
    {
        super.init(imageString: "bullet", initialScale: 3.0)
        self.objectPosition = CGPoint(x: positionX, y: positionY)
        targetPosition = target
        power = damage
        Start()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Move()
    {
        
    }
    
    // Turn toward the target location and move toward it
    override func Start()
    {
        self.zPosition = 1
        self.position = objectPosition ?? CGPoint(x: 1000, y: 1000)
        let offset = CGPoint(x: targetPosition!.x - self.position.x, y: targetPosition!.y - self.position.y)
        let distance = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let duration = 0.01 * distance / 10
        let move = SKAction.move(to: targetPosition!, duration: duration)
        self.run(move)
        // Rotation code from developer.apple.com
        let lookAtConstraint = SKConstraint.orient(to: targetPosition!, offset: SKRange(constantValue: -CGFloat.pi / 2))
        self.constraints = [ lookAtConstraint ]
    }
    
    override func Update()
    {
    }
}
