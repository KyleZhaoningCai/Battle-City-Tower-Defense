/*
 File Name: DefTankPlaceHolder.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit

// The Defending Tank PlaceHolder GameObject
class DefTankPlaceHolder: GameObject
{
    
    var objectPosition: CGPoint?
    
    //constructor
    init(positionX: CGFloat, positionY: CGFloat)
    {
        super.init(imageString: "hole", initialScale: 2.5)
        self.objectPosition = CGPoint(x: positionX, y: positionY)
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
        self.zPosition = 5
        self.position = objectPosition ?? CGPoint(x: 1000, y: 1000)
    }
    
    override func Update()
    {
        
    }
}
