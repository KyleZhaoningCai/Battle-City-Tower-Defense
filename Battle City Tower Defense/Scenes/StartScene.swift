//
//  StartScene.swift
//  Battle City Tower Defense
//
//  Created by Jason on 2020-02-08.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import GameplayKit

class StartScene: SKScene {

    override func didMove(to view: SKView) {
        
        screenWidth = frame.width
        screenHeight = frame.height
        self.logoset()

        
        // ***
    }
    
    func logoset () {
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: 0, y: 700)
        logo.size = CGSize(width: 450, height: 200)
            
        addChild(logo)
        
        let move = SKAction.moveTo(y: 0, duration: 5)
        logo.run(move)
    }

}
