//
//  Hammer.swift
//  Battle City Tower Defense
//
//  Created by Supreet on 2020-02-11.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import Foundation
import Foundation

import SpriteKit
import GameplayKit

class Hammer: GameObject
{
    
    //constructor
    init()
    {
        super.init(imageString: "hammerbutton", initialScale: 4)
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
        self.position = CGPoint(x: 250, y: -520)
    }
    
    override func Update()
    {
        
    }
}
