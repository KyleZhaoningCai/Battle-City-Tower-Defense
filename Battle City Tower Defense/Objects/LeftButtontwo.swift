//
//  LeftButtontwo.swift
//  Battle City Tower Defense
//
//  Created by Supreet on 2020-02-11.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import Foundation

import SpriteKit
import GameplayKit

class LeftButtonTwo: GameObject
{
    
    //constructor
    init()
    {
        super.init(imageString: "YlwTankButton2", initialScale: 4)
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
        self.position = CGPoint(x: -250, y: -480)
    }
    
    override func Update()
    {
        
    }
}
