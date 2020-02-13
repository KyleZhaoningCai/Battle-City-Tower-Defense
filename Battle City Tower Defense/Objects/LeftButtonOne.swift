//
//  leftbutton-1.swift
//  Battle City Tower Defense
//
//  Created by Supreet on 2020-02-11.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import SpriteKit
import GameplayKit

class LeftButtonOne: GameObject
{
    
    //constructor
    init()
    {
        super.init(imageString: "tankBTN1", initialScale: 2)
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
        self.position = CGPoint(x: -250, y: -410)
    }
    
    override func Update()
    {
        
    }
}

