/*
 File Name: EndScene.swift
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


// The end game scene
class EndScene: SKScene {
    
    var endMusicPlayer: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        
        screenWidth = frame.width
        screenHeight = frame.height

        if GameManager.gameState == "gameVictory"{
            let baseImage = SKSpriteNode(imageNamed: "bird")
            baseImage.position = CGPoint(x: 0, y: 300)
            baseImage.size = CGSize(width: 150, height: 150)
            
            addChild(baseImage)
            
            do {
                let path: String = Bundle.main.path(forResource: "GameVictory", ofType: "mp3")!
                let url: URL = URL(fileURLWithPath: path)
                endMusicPlayer = try AVAudioPlayer(contentsOf: url)
                endMusicPlayer?.play()
            } catch {
            }
            
            let result = SKLabelNode(text: "Victory!!")
            result.fontSize = 36
            result.fontColor = SKColor.white
            result.fontName = "SHPinscher-Regular"
            result.position = CGPoint(x:-10, y:0)
            addChild(result)
            
        }
        else{
            let baseImage = SKSpriteNode(imageNamed: "destroyedBase")
            baseImage.position = CGPoint(x: 0, y: 300)
            baseImage.size = CGSize(width: 150, height: 150)
            
            addChild(baseImage)
            
            do {
                let path: String = Bundle.main.path(forResource: "GameOver", ofType: "mp3")!
                let url: URL = URL(fileURLWithPath: path)
                endMusicPlayer = try AVAudioPlayer(contentsOf: url)
                endMusicPlayer?.play()
            } catch {
            }
            
            let result = SKLabelNode(text: "Game Over")
            result.fontSize = 36
            result.fontColor = SKColor.white
            result.fontName = "SHPinscher-Regular"
            result.position = CGPoint(x:-10, y:0)
            addChild(result)
        }
        let score = SKLabelNode(text: "Your Score: " + String(GameManager.playerCoin))
        score.fontSize = 36
        score.fontName = "SHPinscher-Regular"
        score.fontColor = SKColor.white
        score.position = CGPoint(x:-10, y:-100)
        addChild(score)
        
        let startGame = SKLabelNode(text: "Start Over")
        startGame.fontSize = 36
        startGame.fontColor = SKColor.white
        startGame.fontName = "SHPinscher-Regular"
        startGame.name = "start"
        startGame.position = CGPoint(x:10, y:-200)
        addChild(startGame)
        
        let back = SKLabelNode(text: "Back To Menu")
        back.fontSize = 36
        back.fontColor = SKColor.white
        back.fontName = "SHPinscher-Regular"
        back.name = "back"
        back.position = CGPoint(x:25, y:-300)
        addChild(back)
        
        let player1 = SKSpriteNode(imageNamed: "player")
        player1.position = CGPoint(x: -100, y: -188)
        player1.size = CGSize(width: 40, height: 40)
        let lookAtConstraintPlayer = SKConstraint.orient(to: CGPoint(x: 0, y: -188), offset: SKRange(constantValue: -CGFloat.pi / 2))
        player1.constraints = [ lookAtConstraintPlayer ]
        addChild(player1)
        
        let defTank = SKSpriteNode(imageNamed: "ylwTank-1")
        defTank.position = CGPoint(x: -100, y: -288)
        defTank.size = CGSize(width: 40, height: 40)
        let lookAtConstraintTank = SKConstraint.orient(to: CGPoint(x: 0, y: -288), offset: SKRange(constantValue: -CGFloat.pi / 2))
        defTank.constraints = [ lookAtConstraintTank ]
        addChild(defTank)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = atPoint(pos)
        if touchedNode.name == "start" || touchedNode.name == "back"{
            GameManager.waypoints = []
            GameManager.isStoppingPoints = []
            GameManager.targetPoints = []
            GameManager.hasWallCheck = [false, false, false, false, false, false, false]
            GameManager.wallLocations = [
                CGPoint(x: 100, y: (screenHeight!) / 2 - 650),
                CGPoint(x: 100, y: (screenHeight!) / 2 - 750),
                CGPoint(x: 100, y: (screenHeight!) / 2 - 850),
                CGPoint(x: 0, y: (screenHeight!) / 2 - 850),
                CGPoint(x: -100, y: (screenHeight!) / 2 - 850),
                CGPoint(x: -100, y: (screenHeight!) / 2 - 950),
                CGPoint(x: -100, y: (screenHeight!) / 2 - 1050)
            ]
            GameManager.baseHp = 1000
            GameManager.playerCoin = 500
            GameManager.gameState = "onGoing"
            DefManager.hastankcheck = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
            DefManager.tankLocations = [
                CGPoint(x: 255, y: (screenHeight!) / 2 - 700),
                CGPoint(x: 255, y: (screenHeight!) / 2 - 600),
                CGPoint(x: 255, y: (screenHeight!) / 2 - 500),
                CGPoint(x: 255, y: (screenHeight!) / 2 - 400),
                CGPoint(x: 255, y: (screenHeight!) / 2 - 300),
                CGPoint(x: 255, y: (screenHeight!) / 2 - 200),
                CGPoint(x: 155, y: (screenHeight!) / 2 - 200),
                CGPoint(x: 155, y: (screenHeight!) / 2 - 300),
                CGPoint(x: 155, y: (screenHeight!) / 2 - 400),
                CGPoint(x: 55, y: (screenHeight!) / 2 - 400),
                CGPoint(x: 255, y: (screenHeight!) / 2 - 800),
                CGPoint(x: 255, y: (screenHeight!) / 2 - 900),
                CGPoint(x: 255, y: (screenHeight!) / 2 - 1000),
                CGPoint(x: 155, y: (screenHeight!) / 2 - 1000),
                CGPoint(x: 55, y: (screenHeight!) / 2 - 1000),
                CGPoint(x: -255, y: (screenHeight!) / 2 - 1000),
                CGPoint(x: -255, y: (screenHeight!) / 2 - 200),
                CGPoint(x: -255, y: (screenHeight!) / 2 - 900),
                CGPoint(x: -255, y: (screenHeight!) / 2 - 800),
                CGPoint(x: -255, y: (screenHeight!) / 2 - 700),
                CGPoint(x: -255, y: (screenHeight!) / 2 - 600),
                CGPoint(x: -255, y: (screenHeight!) / 2 - 500),
                CGPoint(x: -255, y: (screenHeight!) / 2 - 400),
                CGPoint(x: -155, y: (screenHeight!) / 2 - 700),
                CGPoint(x: -55, y: (screenHeight!) / 2 - 700),
                CGPoint(x: -255, y: (screenHeight!) / 2 - 300)
            ]
            DefManager.baseHp = 1000
            if touchedNode.name == "start"{
                let scene:SKScene = SKScene(fileNamed: "GameScene")!
                scene.scaleMode = .aspectFill
                self.view!.presentScene(scene)
            }
            else if touchedNode.name == "back"{
                let scene:SKScene = SKScene(fileNamed: "StartScene")!
                scene.scaleMode = .aspectFill
                self.view!.presentScene(scene)
            }
        }
        
        self.removeAllActions()
        self.removeAllChildren()
        endMusicPlayer?.stop()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self))  }
    }
    
}
