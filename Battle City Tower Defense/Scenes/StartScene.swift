/*
 File Name: StartScene.swift
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

// The main menu scene class
class StartScene: SKScene {
    
    let startGame = SKLabelNode(text: "Start Game")
    let guide = SKLabelNode(text: "Game Instruction")
    
    var startSoundPlayer: AVAudioPlayer?

    override func didMove(to view: SKView) {
        
        screenWidth = frame.width
        screenHeight = frame.height
        setStartScreen()

        // ***
    }
    
    func setStartScreen () {
        let logo = SKSpriteNode(imageNamed: "logo")
        logo.position = CGPoint(x: 0, y: 700)
        logo.size = CGSize(width: 450, height: 200)
            
        addChild(logo)
        
        let move = SKAction.moveTo(y: 100, duration: 4)
        logo.run(move)
        
        startGame.fontSize = 36
        startGame.fontColor = SKColor.white
        startGame.fontName = "SHPinscher-Regular"
        startGame.name = "start"
        startGame.position = CGPoint(x:10, y:-200)
        addChild(startGame)
        
        let player1 = SKSpriteNode(imageNamed: "player")
        player1.position = CGPoint(x: -100, y: -188)
        player1.size = CGSize(width: 40, height: 40)
        let lookAtConstraintPlayer = SKConstraint.orient(to: CGPoint(x: 0, y: -188), offset: SKRange(constantValue: -CGFloat.pi / 2))
        player1.constraints = [ lookAtConstraintPlayer ]
        addChild(player1)
        
        guide.fontSize = 36
        guide.fontColor = SKColor.white
        guide.fontName = "SHPinscher-Regular"
        guide.name = "guide"
        guide.position = CGPoint(x:50, y:-300)
        addChild(guide)
        
        let defTank = SKSpriteNode(imageNamed: "ylwTank-1")
        defTank.position = CGPoint(x: -100, y: -288)
        defTank.size = CGSize(width: 40, height: 40)
        let lookAtConstraintTank = SKConstraint.orient(to: CGPoint(x: 0, y: -288), offset: SKRange(constantValue: -CGFloat.pi / 2))
        defTank.constraints = [ lookAtConstraintTank ]
        addChild(defTank)
        do {
            let path: String = Bundle.main.path(forResource: "start", ofType: "mp3")!
            let url: URL = URL(fileURLWithPath: path)
            startSoundPlayer = try AVAudioPlayer(contentsOf: url)
            startSoundPlayer?.play()
        } catch {
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = atPoint(pos)
        if touchedNode.name == "start"{
            let scene:SKScene = SKScene(fileNamed: "GameScene")!
            scene.scaleMode = .aspectFill
            self.view!.presentScene(scene)
            self.removeAllActions()
            self.removeAllChildren()
            startSoundPlayer?.stop()
        }
        else if touchedNode.name == "guide"{
            let scene:SKScene = SKScene(fileNamed: "GuideScene")!
            scene.scaleMode = .aspectFill
            self.view!.presentScene(scene)
            self.removeAllActions()
            self.removeAllChildren()
            startSoundPlayer?.stop()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self))  }
    }
    
}
