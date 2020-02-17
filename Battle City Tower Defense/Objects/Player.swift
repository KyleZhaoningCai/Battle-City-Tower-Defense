/*
 File Name: Player.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit

// The player aircraft GameObject
class Player: GameObject
{
    var currentTask: String = ""
    var itemIndex: Int = 0
    var targetLocation: CGPoint?
    //constructor
    init()
    {
        super.init(imageString: "player", initialScale: 2)
        Start()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Move to target location
    func Move()
    {
        self.removeAllActions()
        let distance = getDistance()
        let duration = 0.02 * distance / 10
        let move = SKAction.move(to: targetLocation!, duration: duration)
        self.run(move)
        // Rotation code from developer.apple.com
        if (self.position != targetLocation!){
            let lookAtConstraint = SKConstraint.orient(to: targetLocation!, offset: SKRange(constantValue: -CGFloat.pi / 2))
            self.constraints = [ lookAtConstraint ]
        }
    }
    
    // Get distance between itself and the target location
    func getDistance() -> Double{
        let offset = CGPoint(x: targetLocation!.x - self.position.x, y: targetLocation!.y - self.position.y)
        let distance = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        return distance
    }
    
    // Clear all actions and move back to default location
    func clearAction(){
        currentTask = ""
        targetLocation = CGPoint(x: 255, y: -425)
        Move()
    }

    override func Start()
    {
        self.position = CGPoint(x: 255, y: -425)
        self.zPosition = 10
    }
    
    override func Update()
    {
        
    }
}
