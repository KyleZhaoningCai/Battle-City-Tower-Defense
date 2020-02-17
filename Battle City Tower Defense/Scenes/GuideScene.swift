/*
 File Name: GuideScene.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import UIKit
import AVFoundation
import SpriteKit
import GameplayKit

// The game guide scene
class GuideScene: SKScene {
        
    override func didMove(to view: SKView) {
        
        screenWidth = frame.width
        screenHeight = frame.height
        setGuideScreen()
        
        // ***
    }
    
    func setGuideScreen () {
        let screenshot = SKSpriteNode(imageNamed: "screenshot")
        screenshot.position = CGPoint(x: 0, y: 80)
        screenshot.size = CGSize(width: 350, height: 800)
        
        addChild(screenshot)
        
        let instruction1 = SKLabelNode(text: "Kill 8 waves of enemy tanks to win")
        instruction1.fontSize = 36
        instruction1.fontColor = SKColor.white
        instruction1.fontName = "SHPinscher-Regular"
        instruction1.position = CGPoint(x:0, y: 550)
        addChild(instruction1)
        
        let instruction2 = SKLabelNode(text: "You lose if your base is destroyed")
        instruction2.fontSize = 36
        instruction2.fontColor = SKColor.white
        instruction2.fontName = "SHPinscher-Regular"
        instruction2.position = CGPoint(x:0, y: 500)
        addChild(instruction2)
        
        let instruction3 = SKLabelNode(text: "Press a bottom left button to place a tank")
        instruction3.fontSize = 36
        instruction3.fontColor = SKColor.white
        instruction3.fontName = "SHPinscher-Regular"
        instruction3.position = CGPoint(x:0, y: -370)
        addChild(instruction3)
        
        let instruction4 = SKLabelNode(text: "& the wall button on the right to place a wall")
        instruction4.fontSize = 36
        instruction4.fontColor = SKColor.white
        instruction4.fontName = "SHPinscher-Regular"
        instruction4.position = CGPoint(x:0, y: -420)
        addChild(instruction4)
        
        let instruction5 = SKLabelNode(text: "The costs are displayed beside them")
        instruction5.fontSize = 36
        instruction5.fontColor = SKColor.white
        instruction5.fontName = "SHPinscher-Regular"
        instruction5.position = CGPoint(x:0, y: -470)
        addChild(instruction5)
        
        let instruction6 = SKLabelNode(text: "Remove your own wall and tanks with hammer")
        instruction6.fontSize = 36
        instruction6.fontColor = SKColor.white
        instruction6.fontName = "SHPinscher-Regular"
        instruction6.position = CGPoint(x:0, y: -520)
        addChild(instruction6)
        
        let back = SKLabelNode(text: "Back To Menu")
        back.fontSize = 40
        back.fontColor = SKColor.white
        back.fontName = "SHPinscher-Regular"
        back.name = "back"
        back.position = CGPoint(x:0, y: -600)
        addChild(back)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = atPoint(pos)
        if touchedNode.name == "back"{
            let scene:SKScene = SKScene(fileNamed: "StartScene")!
            scene.scaleMode = .aspectFill
            self.view!.presentScene(scene)
            self.removeAllActions()
            self.removeAllChildren()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self))  }
    }
    
}
