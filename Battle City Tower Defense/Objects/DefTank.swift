/*
 File Name: DefTank.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit

// The Defending Tank GameObject
class DefTank: GameObject
{
    
    //constructor
    init()
    {
        super.init(imageString: "ylwTank-2", initialScale: 5)
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
        self.position = CGPoint(x: 255, y: (screenHeight!) / 2 - 1200)
        //self.position = CGPoint(x: -250, y: 200)
    }
    
    override func Update()
    {
        
    }
}
