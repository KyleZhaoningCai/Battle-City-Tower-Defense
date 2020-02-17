/*
 File Name: BOOM.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit
import AVFoundation

// The BOOM effect GameObject
class BOOM: GameObject
{
    var boomlocation: CGPoint?

    

    //constructor
    init(location: CGPoint)
    {
        super.init(imageString: "boom", initialScale: 2)
        boomlocation = location
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
        self.position = boomlocation!
    }
    
    override func Update()
    {
        
    }
}
