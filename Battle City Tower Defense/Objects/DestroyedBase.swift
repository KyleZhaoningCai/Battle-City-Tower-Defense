/*
 File Name: DestroyedBase.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit

// The DestroyedBase GameObject
class DestroyedBase: GameObject
{
    
    //constructor
    init()
    {
        super.init(imageString: "destroyedBase", initialScale: 4)
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
        self.position = GameManager.basePosition
    }
    
    override func Update()
    {
        
    }
}
