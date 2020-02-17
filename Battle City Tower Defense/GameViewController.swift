/*
 File Name: GameViewController.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

// The game view controller class
class GameViewController: UIViewController {
    
    @IBOutlet weak var StartBtn: UIButton!
    var currentScene: SKScene?
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SetScene(sceneName: "StartScene")
    }
    
    func SetScene(sceneName: String)
    {
        if let view = self.view as! SKView?
        {
            // Load the SKScene from 'GameScene.sks'
            currentScene = SKScene(fileNamed: sceneName)
            
            //            if let gameScene = currentScene as? GameScene
            //            {
            //                gameScene.gameManager = self
            //            }
            
            // Set the scale mode to scale to fit the window
            currentScene?.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(currentScene)
            
            
            view.ignoresSiblingOrder = true
            
        }
    }
    
}
