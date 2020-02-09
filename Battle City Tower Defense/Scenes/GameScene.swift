//
//  GameScene.swift
//  Battle City Tower Defense
//
//  Created by Zhaoning Cai on 2020-02-08.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import GameplayKit

let screenSize = UIScreen.main.bounds
var screenWidth: CGFloat?
var screenHeight: CGFloat?

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        screenWidth = frame.width
        screenHeight = frame.height
        
        // Set up static tiles on the map
        self.setUpStaticTiles()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func setUpStaticTiles(){
        // ** Object initiation to be cahnged to using GameObject class
        var river = River(positionX: -75, positionY: (screenHeight!) / 2 - 75)
        
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 75, y: (screenHeight!) / 2 - 75)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -75, y: (screenHeight!) / 2 - 125)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 75, y: (screenHeight!) / 2 - 125)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -75, y: (screenHeight!) / 2 - 175)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 75, y: (screenHeight!) / 2 - 175)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 75, y: (screenHeight!) / 2 - 225)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 75, y: (screenHeight!) / 2 - 275)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 75, y: (screenHeight!) / 2 - 325)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -125, y: (screenHeight!) / 2 - 175)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y: (screenHeight!) / 2 - 175)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 25, y: (screenHeight!) / 2 - 325)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y: (screenHeight!) / 2 - 325)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y: (screenHeight!) / 2 - 225)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y: (screenHeight!) / 2 - 375)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y: (screenHeight!) / 2 - 275)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y: (screenHeight!) / 2 - 325)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y: (screenHeight!) / 2 - 375)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 425)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y: (screenHeight!) / 2 - 425)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 475)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 525)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 575)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -125, y:  (screenHeight!) / 2 - 625)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -75, y:  (screenHeight!) / 2 - 625)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 625)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 25, y:  (screenHeight!) / 2 - 625)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 625)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 475)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 25, y:  (screenHeight!) / 2 - 475)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 75, y:  (screenHeight!) / 2 - 475)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 125, y:  (screenHeight!) / 2 - 475)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 475)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 525)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 575)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 625)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 675)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 25, y:  (screenHeight!) / 2 - 775)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 725)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 775)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 825)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 125, y:  (screenHeight!) / 2 - 925)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 75, y:  (screenHeight!) / 2 - 925)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 25, y:  (screenHeight!) / 2 - 925)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 775)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -75, y:  (screenHeight!) / 2 - 775)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -125, y:  (screenHeight!) / 2 - 775)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 25, y:  (screenHeight!) / 2 - 675)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 875)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 925)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 25, y:  (screenHeight!) / 2 - 725)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 775)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 825)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 875)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 925)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 925)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 975)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 975)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 1025)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 1025)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 1075)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 1125)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 1175)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 1225)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 1275)
        addChild(river)
        // Unbreakable wall starts here *******
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 1075)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 25, y:  (screenHeight!) / 2 - 1075)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 75, y:  (screenHeight!) / 2 - 1075)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 125, y:  (screenHeight!) / 2 - 1075)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 1075)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 1125)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 1175)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 1225)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 1275)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: 175, y:  (screenHeight!) / 2 - 1325)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -175, y:  (screenHeight!) / 2 - 1325)
        addChild(river)
        // Unbreakable wall ends here ******
        // Base brick wall starts here ******
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 1125)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 1175)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 1225)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 1275)
        addChild(river)
        river = SKSpriteNode(imageNamed: "river")
        river.size = CGSize(width: 50, height: 50)
        river.position = CGPoint(x: -25, y:  (screenHeight!) / 2 - 1325)
        addChild(river)
        // Base brick wall ends here ******
    }
}
