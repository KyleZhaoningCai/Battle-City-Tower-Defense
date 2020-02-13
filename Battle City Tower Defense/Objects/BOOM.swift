//
//  BOOM.swift
//  Battle City Tower Defense
//
//  Created by Jason on 2020-02-12.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

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
