/*
 File Name: Hit.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit

// The Hit effect GameObject
class Hit: GameObject
{
    var location: CGPoint?
    //constructor
    init(spawnLocation: CGPoint)
    {
        super.init(imageString: "hit", initialScale: 2)
        location = spawnLocation
        Start()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Move()
    {
        
    }
    
    override func Start()
    {
        self.position = location!
        self.zPosition = 6
        self.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 0.2),
                SKAction.removeFromParent()
                ])
        )
    }
    
    override func Update()
    {
        
    }
}
