//
//  DefTankPlaceHolder.swift
//  Battle City Tower Defense
//
//  Created by Jason on 2020-02-11.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import SpriteKit
import GameplayKit

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
