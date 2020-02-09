//
//  GameViewController.swift
//  Battle City Tower Defense
//
//  Created by Zhaoning Cai on 2020-02-08.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var StartBtn: UIButton!
    var currentScene: SKScene?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SetScene(sceneName: "StartScene")
    }

    @IBAction func StartBtn(_ sender: UIButton)
    {
        StartBtn.isHidden = true

        SetScene(sceneName: "GameScene")
        
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
