/*
 File Name: LeftButtonFour.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */
import Foundation

import SpriteKit
import GameplayKit

// The LeftButtonFour GameObject
class LeftButtonFour: GameObject
{
    
    //constructor
    init()
    {
        super.init(imageString: "TankBTN4", initialScale: 2)
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
        self.position = CGPoint(x: -242, y: -620)
    }
    
    override func Update()
    {
        
    }
}
