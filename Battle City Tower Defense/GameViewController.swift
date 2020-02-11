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
import AVFoundation

class GameViewController: UIViewController {
    
    @IBOutlet weak var StartBtn: UIButton!
    var currentScene: SKScene?
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SetScene(sceneName: "StartScene")
        StartBtn.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            self.StartBtn.isHidden = false
        }
        
        let audioplayer = Bundle.main.path(forResource: "start", ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioplayer!))
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func StartBtn(_ sender: UIButton)
    {
        StartBtn.isHidden = true
        
        SetScene(sceneName: "GameScene")
        
        audioPlayer.play()
        
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
