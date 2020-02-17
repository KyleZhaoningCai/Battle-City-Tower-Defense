/*
 File Name: BrickWall.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit


// The player placed BrickWall GameObject
class BrickWall: GameObject
{
    
    var objectPosition: CGPoint?
    var hp = 100
    var index: Int?
    
    //constructor
    init(positionX: CGFloat, positionY: CGFloat, checkWallIndex: Int)
    {
        super.init(imageString: "largeBrickWall", initialScale: 3.1)
        self.objectPosition = CGPoint(x: positionX, y: positionY)
        index = checkWallIndex
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
        self.position = objectPosition ?? CGPoint(x: 1000, y: 1000)
    }
    
    override func Update()
    {
        
    }
    
    // Reduce its own hp by certain amount
    func reductHp(amount: Int){
        hp -= amount
    }
}
