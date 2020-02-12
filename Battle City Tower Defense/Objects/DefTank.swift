//
//  Hole.swift
//  Battle City Tower Defense
//
//  Created by Jason on 2020-02-11.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import SpriteKit
import GameplayKit

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
