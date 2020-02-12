//
//  GameUI.swift
//  Battle City Tower Defense
//
//  Created by Supreet on 2020-02-11.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameUI: GameObject
{
    
    var objectPosition: CGPoint?
    
      
    func Move()
    {

         basewallHP.verticalAlignmentMode = .top
          basewallHP.horizontalAlignmentMode = .left
        
          basewallHP.fontSize = 20
          basewallHP.fontColor = SKColor.white
          basewallHP.fontName = "Avenir"
          basewallHP.position = CGPoint(x:-300,y:190)
          addChild(basewallHP)
          
          Coins.verticalAlignmentMode = .top
          Coins.horizontalAlignmentMode = .right
          
           Coins.fontSize = 20
           Coins.fontColor = SKColor.white
           Coins.fontName = "Avenir"
           addChild(Coins)
         
    }
    
    override func Start()
    {
        self.position = objectPosition ?? CGPoint(x: 1000, y: 1000)
    }
    
    override func Update()
    {

    }
}
