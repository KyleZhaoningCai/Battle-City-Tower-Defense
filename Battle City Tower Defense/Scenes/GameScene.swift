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
    
    let waveInterval: Double = 5
    let spawnInterval: Double = 2
    let numberOfEnemy = 8
    let finalWaypoints: [CGPoint] = [
        CGPoint(x: 120, y:  -475),
        CGPoint(x: -100, y:  -625),
        CGPoint(x: 70, y:  -475),
        CGPoint(x: -100, y:  -575),
        CGPoint(x: 20, y:  -475),
        CGPoint(x: -100, y:  -525),
        CGPoint(x: -30, y:  -475),
        CGPoint(x: -90, y:  -475)
    ]
    
    var currentWave = 1
    var currentSpawn = 0
    var spawningEnemyTanks = false
    var startingNextWave = true
    var endTime: Date?
    var nextSpawnTime: Date?
    var enemyTanks: [Enemy] = []
    var brickWallPlaceholders: [BrickWallPlaceholder] = []
    var base: Base?
    var awaitingWallPlacement = false
    var enemyBullets: [Bullet] = []
    var currentWaypoint: Int = 99
    var brickWalls: [BrickWall] = []
    var baseWalls: [BaseWall] = []
    var wallButtonCheat: Int = 3
    var waypointsFinalized = false
    var player: Player?
    
    override func didMove(to view: SKView) {
        
        screenWidth = frame.width
        screenHeight = frame.height
        
        player = Player()
        addChild(player!)
        
        // Set up static tiles on the map
        setUpStaticTiles()
        // Set up brick wall placeholders
        setUpBrickWallPlaceholders()
        
        base = Base()
        addChild(base!)
        
        // *** to be changed later
        let tempButton = TempButton()
        addChild(tempButton)
        
        // ***
        
        // preload sounds
        do {
            let sounds:[String] = ["destroy", "fire", "tankTravel", "wallHit"]
            for sound in sounds
            {
                let path: String = Bundle.main.path(forResource: sound, ofType: "wav")!
                let url: URL = URL(fileURLWithPath: path)
                let player: AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
            }
        } catch {
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = atPoint(pos)
        if touchedNode.name == "grass"{
            wallButtonCheat -= 1
            if (!spawningEnemyTanks){
                awaitingWallPlacement = !awaitingWallPlacement
                if (awaitingWallPlacement){
                    for index in 0..<brickWallPlaceholders.count{
                        if !GameManager.hasWallCheck[index]{
                            brickWallPlaceholders[index].isHidden = false
                        }
                    }
                }
                else{
                    turnOffBrickWallPlaceholders()
                }
            }
        }
        if touchedNode.name == "placeholder"{
            resetWallButtonCheatCount()
            for index in 0..<brickWallPlaceholders.count{
                if brickWallPlaceholders[index] == touchedNode{
                    player?.currentTask = "wall"
                    player?.itemIndex = index
                    player?.targetLocation = brickWallPlaceholders[index].position
                    player?.Move()
                    break
                }
            }
        }
        if (touchedNode.name == "silverTank2" || touchedNode.name == "silverTankFast1" || touchedNode.name == "silverTankHeavy1" || touchedNode.name == "greenTank2" || touchedNode.name == "greenTankFast1" || touchedNode.name == "greenTankHeave1" || touchedNode.name == "redTank2" || touchedNode.name == "redTankHeave1"){
            if (wallButtonCheat <= 0){
                let enemy: Enemy = touchedNode as! Enemy
                enemy.removeHp(hp: 99999)
                if (enemy.tankHealth <= 0){
                    if (enemyTanks.count > 0){
                        for index in 0..<enemyTanks.count{
                            if enemy == enemyTanks[index]{
                                enemy.removeFromParent()
                                enemyTanks.remove(at: index)
                                break
                            }
                        }
                    }
                }
            }
            resetWallButtonCheatCount()
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
        }
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
        // Timer tutorial from https://tutorials.tinyappco.com/SwiftGames/Timer
        if (startingNextWave){
            startingNextWave = false
            let timeNow = Date()
            endTime = timeNow.addingTimeInterval(waveInterval)
        }
        else{
            if (!spawningEnemyTanks){
                let remainingSeconds = Int(endTime!.timeIntervalSinceNow)
                if (remainingSeconds <= 0){
                    spawningEnemyTanks = true
                    enemyTanks = []
                    currentSpawn = 0
                    nextSpawnTime = Date()
                    turnOffBrickWallPlaceholders()
                    player?.clearAction()
                }
            }
        }
        if (spawningEnemyTanks){
            if (!waypointsFinalized){
                GameManager.waypoints.append(CGPoint(x: 0, y:  425))
                GameManager.isStoppingPoints.append(false)
                GameManager.targetPoints.append(CGPoint(x: 1000, y: 1000))
                GameManager.waypoints.append(CGPoint(x: -100, y:  425))
                GameManager.isStoppingPoints.append(false)
                GameManager.targetPoints.append(CGPoint(x: 1000, y: 1000))
                GameManager.waypoints.append(CGPoint(x: -100, y:  125))
                GameManager.isStoppingPoints.append(false)
                GameManager.targetPoints.append(CGPoint(x: 1000, y: 1000))
                GameManager.waypoints.append(CGPoint(x: 100, y:  125))
                GameManager.isStoppingPoints.append(false)
                GameManager.targetPoints.append(CGPoint(x: 1000, y: 1000))
                if (GameManager.hasWallCheck[0]){
                    GameManager.waypoints.append(CGPoint(x: 100, y:  115))
                    GameManager.isStoppingPoints.append(true)
                    GameManager.targetPoints.append(GameManager.wallLocations[0])
                }
                if (GameManager.hasWallCheck[1]){
                    GameManager.waypoints.append(CGPoint(x: 100, y:  15))
                    GameManager.isStoppingPoints.append(true)
                    GameManager.targetPoints.append(GameManager.wallLocations[1])
                }
                if (GameManager.hasWallCheck[2]){
                    GameManager.waypoints.append(CGPoint(x: 100, y:  -85))
                    GameManager.isStoppingPoints.append(true)
                    GameManager.targetPoints.append(GameManager.wallLocations[2])
                }
                GameManager.waypoints.append(CGPoint(x: 100, y:  -175))
                GameManager.isStoppingPoints.append(false)
                GameManager.targetPoints.append(CGPoint(x: 1000, y: 1000))
                if (GameManager.hasWallCheck[3]){
                    GameManager.waypoints.append(CGPoint(x: 90, y:  -175))
                    GameManager.isStoppingPoints.append(true)
                    GameManager.targetPoints.append(GameManager.wallLocations[3])
                }
                if (GameManager.hasWallCheck[4]){
                    GameManager.waypoints.append(CGPoint(x: 0, y:  -175))
                    GameManager.isStoppingPoints.append(true)
                    GameManager.targetPoints.append(GameManager.wallLocations[4])
                }
                GameManager.waypoints.append(CGPoint(x: -100, y:  -175))
                GameManager.isStoppingPoints.append(false)
                GameManager.targetPoints.append(CGPoint(x: 1000, y: 1000))
                if (GameManager.hasWallCheck[5]){
                    GameManager.waypoints.append(CGPoint(x: -100, y:  -185))
                    GameManager.isStoppingPoints.append(true)
                    GameManager.targetPoints.append(GameManager.wallLocations[5])
                }
                if (GameManager.hasWallCheck[6]){
                    GameManager.waypoints.append(CGPoint(x: -100, y:  -285))
                    GameManager.isStoppingPoints.append(true)
                    GameManager.targetPoints.append(GameManager.wallLocations[6])
                }
                GameManager.waypoints.append(CGPoint(x: -100, y:  -475))
                GameManager.isStoppingPoints.append(false)
                GameManager.targetPoints.append(CGPoint(x: 1000, y: 1000))
                waypointsFinalized = true
            }
            switch (currentWave){
                case 1:
                    if (currentSpawn < numberOfEnemy){
                        let remainingSeconds = Int(nextSpawnTime!.timeIntervalSinceNow)
                        if (remainingSeconds <= 0){
                            let enemy = Enemy(imageString: "silverTank2", finalWaypoint: finalWaypoints[currentSpawn], damage: 10, fireInterval: 1, health: 20, speed: 0.1)
                            addChild(enemy)
                            enemyTanks.append(enemy)
                            currentSpawn += 1
                            let timeNow = Date()
                            nextSpawnTime = timeNow.addingTimeInterval(spawnInterval)
                        }
                    }
                    break;
                case 2:
                    if (currentSpawn < numberOfEnemy){
                        let remainingSeconds = Int(nextSpawnTime!.timeIntervalSinceNow)
                        if (remainingSeconds <= 0){
                            let enemy = Enemy(imageString: "silverTankFast1", finalWaypoint: finalWaypoints[currentSpawn], damage: 10, fireInterval: 0.5, health: 20, speed: 0.07)
                            addChild(enemy)
                            enemyTanks.append(enemy)
                            currentSpawn += 1
                            let timeNow = Date()
                            nextSpawnTime = timeNow.addingTimeInterval(spawnInterval)
                        }
                    }
                    break;
                case 3:
                    if (currentSpawn < numberOfEnemy){
                        let remainingSeconds = Int(nextSpawnTime!.timeIntervalSinceNow)
                        if (remainingSeconds <= 0){
                            let enemy = Enemy(imageString: "silverTankHeavy1", finalWaypoint: finalWaypoints[currentSpawn], damage: 30, fireInterval: 0.5, health: 40, speed: 0.13)
                            addChild(enemy)
                            enemyTanks.append(enemy)
                            currentSpawn += 1
                            let timeNow = Date()
                            nextSpawnTime = timeNow.addingTimeInterval(spawnInterval)
                        }
                    }
                    break;
                case 4:
                    if (currentSpawn < numberOfEnemy){
                        let remainingSeconds = Int(nextSpawnTime!.timeIntervalSinceNow)
                        if (remainingSeconds <= 0){
                            let enemy = Enemy(imageString: "greenTank2", finalWaypoint: finalWaypoints[currentSpawn], damage: 20, fireInterval: 0.4, health: 30, speed: 0.09)
                            addChild(enemy)
                            enemyTanks.append(enemy)
                            currentSpawn += 1
                            let timeNow = Date()
                            nextSpawnTime = timeNow.addingTimeInterval(spawnInterval)
                        }
                    }
                    break;
                case 5:
                    if (currentSpawn < numberOfEnemy){
                        let remainingSeconds = Int(nextSpawnTime!.timeIntervalSinceNow)
                        if (remainingSeconds <= 0){
                            let enemy = Enemy(imageString: "greenTankFast1", finalWaypoint: finalWaypoints[currentSpawn], damage: 20, fireInterval: 0.4, health: 30, speed: 0.05)
                            addChild(enemy)
                            enemyTanks.append(enemy)
                            currentSpawn += 1
                            let timeNow = Date()
                            nextSpawnTime = timeNow.addingTimeInterval(spawnInterval)
                        }
                    }
                    break;
                case 6:
                    if (currentSpawn < numberOfEnemy){
                        let remainingSeconds = Int(nextSpawnTime!.timeIntervalSinceNow)
                        if (remainingSeconds <= 0){
                            let enemy = Enemy(imageString: "greenTankHeave1", finalWaypoint: finalWaypoints[currentSpawn], damage: 50, fireInterval: 0.4, health: 70, speed: 0.1)
                            addChild(enemy)
                            enemyTanks.append(enemy)
                            currentSpawn += 1
                            let timeNow = Date()
                            nextSpawnTime = timeNow.addingTimeInterval(spawnInterval)
                        }
                    }
                    break;
                case 7:
                    if (currentSpawn < numberOfEnemy){
                        let remainingSeconds = Int(nextSpawnTime!.timeIntervalSinceNow)
                        if (remainingSeconds <= 0){
                            let enemy = Enemy(imageString: "redTank2", finalWaypoint: finalWaypoints[currentSpawn], damage: 40, fireInterval: 0.3, health: 50, speed: 0.08)
                            addChild(enemy)
                            enemyTanks.append(enemy)
                            currentSpawn += 1
                            let timeNow = Date()
                            nextSpawnTime = timeNow.addingTimeInterval(spawnInterval)
                        }
                    }
                    break;
                case 8:
                    if (currentSpawn < 7){
                        currentSpawn = 7
                        let remainingSeconds = Int(nextSpawnTime!.timeIntervalSinceNow)
                        if (remainingSeconds <= 0){
                            let enemy = Enemy(imageString: "redTankHeavy1", finalWaypoint: finalWaypoints[currentSpawn], damage: 100, fireInterval: 0.2, health: 1000, speed: 0.1)
                            addChild(enemy)
                            enemyTanks.append(enemy)
                            currentSpawn += 1
                        }
                    }
                    break;
                default:
                    break;
            }
        }
        if (enemyTanks.count > 0){
            var stoppingOthers = false
            for tank in enemyTanks
            {
                if (tank.stopOthers){
                    stoppingOthers = true
                    currentWaypoint = tank.currentWaypoint
                }
                else{
                    if (stoppingOthers){
                        tank.state = "paused"
                    }
                    else{
                        if (tank.state == "paused"){
                            tank.state = "stopped"
                        }
                    }
                }
                tank.Update()
            }
        }
        else{
            if (spawningEnemyTanks){
                if (currentWave < 8 && currentSpawn >= numberOfEnemy){
                    spawningEnemyTanks = false
                    startingNextWave = true
                    waypointsFinalized = false
                    GameManager.waypoints = []
                    GameManager.isStoppingPoints = []
                    GameManager.targetPoints = []
                    currentWave += 1
                }
                
            }
        }
        if (enemyBullets.count > 0){
            for enemyBullet in enemyBullets{
                if (brickWalls.count > 0){
                    for brickWall in brickWalls{
                        CollisionManager.squaredRadiusCheck(scene: self, object1: enemyBullet, object2: brickWall)
                    }
                }
                if (baseWalls.count > 0){
                    for baseWall in baseWalls{
                        CollisionManager.squaredRadiusCheck(scene: self, object1: enemyBullet, object2: baseWall)
                    }
                }
                if (GameManager.baseHp <= 0 && base != nil){
                    CollisionManager.squaredRadiusCheck(scene: self, object1: enemyBullet, object2: base!)
                }
            }
        }
        if (player?.currentTask != ""){
            if (player?.getDistance())! < 5{
                if (player?.currentTask == "wall"){
                    if (GameManager.playerCoin >= 300){
                        GameManager.hasWallCheck[(player?.itemIndex)!] = true
                        spawnBrickWall(location: brickWallPlaceholders[(player?.itemIndex)!].position, index: (player?.itemIndex)!)
                        GameManager.playerCoin -= 300
                    }else{
                        // warn player not enough coins
                    }
                    player?.clearAction()
                }
            }
        }
    }
    
    func spawnBrickWall(location: CGPoint, index: Int){
        let brickWall = BrickWall(positionX: location.x, positionY: location.y, checkWallIndex: index)
        brickWalls.append(brickWall)
        addChild(brickWall)
        turnOffBrickWallPlaceholders()
    }
    
    func turnOffBrickWallPlaceholders(){
        for brickWallPlaceholder in brickWallPlaceholders{
            brickWallPlaceholder.isHidden = true
            awaitingWallPlacement = false
        }
    }
    
    func resetWallButtonCheatCount(){
        wallButtonCheat = 3
    }
    
    func setUpBrickWallPlaceholders(){
        var brickWallPlaceholder = BrickWallPlaceholder(positionX: GameManager.wallLocations[0].x, positionY: GameManager.wallLocations[0].y)
        brickWallPlaceholder.isHidden = true
        addChild(brickWallPlaceholder)
        brickWallPlaceholders.append(brickWallPlaceholder)
        brickWallPlaceholder = BrickWallPlaceholder(positionX: GameManager.wallLocations[1].x, positionY: GameManager.wallLocations[1].y)
        brickWallPlaceholder.isHidden = true
        addChild(brickWallPlaceholder)
        brickWallPlaceholders.append(brickWallPlaceholder)
        brickWallPlaceholder = BrickWallPlaceholder(positionX: GameManager.wallLocations[2].x, positionY: GameManager.wallLocations[2].y)
        brickWallPlaceholder.isHidden = true
        addChild(brickWallPlaceholder)
        brickWallPlaceholders.append(brickWallPlaceholder)
        brickWallPlaceholder = BrickWallPlaceholder(positionX: GameManager.wallLocations[3].x, positionY: GameManager.wallLocations[3].y)
        brickWallPlaceholder.isHidden = true
        addChild(brickWallPlaceholder)
        brickWallPlaceholders.append(brickWallPlaceholder)
        brickWallPlaceholder = BrickWallPlaceholder(positionX: GameManager.wallLocations[4].x, positionY: GameManager.wallLocations[4].y)
        brickWallPlaceholder.isHidden = true
        addChild(brickWallPlaceholder)
        brickWallPlaceholders.append(brickWallPlaceholder)
        brickWallPlaceholder = BrickWallPlaceholder(positionX: GameManager.wallLocations[5].x, positionY: GameManager.wallLocations[5].y)
        brickWallPlaceholder.isHidden = true
        addChild(brickWallPlaceholder)
        brickWallPlaceholders.append(brickWallPlaceholder)
        brickWallPlaceholder = BrickWallPlaceholder(positionX: GameManager.wallLocations[6].x, positionY: GameManager.wallLocations[6].y)
        brickWallPlaceholder.isHidden = true
        addChild(brickWallPlaceholder)
        brickWallPlaceholders.append(brickWallPlaceholder)
    }
    
    func setUpStaticTiles(){
        // ** Object initiation to be cahnged to using GameObject class
        var river = River(positionX: -75, positionY: (screenHeight!) / 2 - 75)
        addChild(river)
        river = River(positionX: 75, positionY: (screenHeight!) / 2 - 75)
        addChild(river)
        river = River(positionX: -75, positionY: (screenHeight!) / 2 - 125)
        addChild(river)
        river = River(positionX: 75, positionY: (screenHeight!) / 2 - 125)
        addChild(river)
        river = River(positionX: -75, positionY: (screenHeight!) / 2 - 175)
        addChild(river)
        river = River(positionX: 75, positionY: (screenHeight!) / 2 - 175)
        addChild(river)
        river = River(positionX: 75, positionY: (screenHeight!) / 2 - 225)
        addChild(river)
        river = River(positionX: 75, positionY: (screenHeight!) / 2 - 275)
        addChild(river)
        river = River(positionX: 75, positionY: (screenHeight!) / 2 - 325)
        addChild(river)
        river = River(positionX: -125, positionY: (screenHeight!) / 2 - 175)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 175)
        addChild(river)
        river = River(positionX: 25, positionY: (screenHeight!) / 2 - 325)
        addChild(river)
        river = River(positionX: -25, positionY: (screenHeight!) / 2 - 325)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 225)
        addChild(river)
        river = River(positionX: -25, positionY: (screenHeight!) / 2 - 375)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 275)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 325)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 375)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 425)
        addChild(river)
        river = River(positionX: -25, positionY: (screenHeight!) / 2 - 425)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 475)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 525)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 575)
        addChild(river)
        river = River(positionX: -125, positionY: (screenHeight!) / 2 - 625)
        addChild(river)
        river = River(positionX: -75, positionY: (screenHeight!) / 2 - 625)
        addChild(river)
        river = River(positionX: -25, positionY: (screenHeight!) / 2 - 625)
        addChild(river)
        river = River(positionX: 25, positionY: (screenHeight!) / 2 - 625)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 625)
        addChild(river)
        river = River(positionX: -25, positionY: (screenHeight!) / 2 - 475)
        addChild(river)
        river = River(positionX: 25, positionY: (screenHeight!) / 2 - 475)
        addChild(river)
        river = River(positionX: 75, positionY: (screenHeight!) / 2 - 475)
        addChild(river)
        river = River(positionX: 125, positionY: (screenHeight!) / 2 - 475)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 475)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 525)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 575)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 625)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 675)
        addChild(river)
        river = River(positionX: 25, positionY: (screenHeight!) / 2 - 775)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 725)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 775)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 825)
        addChild(river)
        river = River(positionX: 125, positionY: (screenHeight!) / 2 - 925)
        addChild(river)
        river = River(positionX: 75, positionY: (screenHeight!) / 2 - 925)
        addChild(river)
        river = River(positionX: 25, positionY: (screenHeight!) / 2 - 925)
        addChild(river)
        river = River(positionX: -25, positionY: (screenHeight!) / 2 - 775)
        addChild(river)
        river = River(positionX: -75, positionY: (screenHeight!) / 2 - 775)
        addChild(river)
        river = River(positionX: -125, positionY: (screenHeight!) / 2 - 775)
        addChild(river)
        river = River(positionX: 25, positionY: (screenHeight!) / 2 - 675)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 875)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 925)
        addChild(river)
        river = River(positionX: 25, positionY: (screenHeight!) / 2 - 725)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 775)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 825)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 875)
        addChild(river)
        river = River(positionX: -25, positionY: (screenHeight!) / 2 - 925)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 925)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 975)
        addChild(river)
        river = River(positionX: -25, positionY: (screenHeight!) / 2 - 975)
        addChild(river)
        river = River(positionX: -25, positionY: (screenHeight!) / 2 - 1025)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 1025)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 1075)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 1125)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 1175)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 1225)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 1275)
        addChild(river)
        river = River(positionX: -175, positionY: (screenHeight!) / 2 - 1325)
        addChild(river)
        // Unbreakable wall starts here *******
        var unbreakableWall = UnbreakableWall(positionX: -25, positionY: (screenHeight!) / 2 - 1075)
        addChild(unbreakableWall)
        unbreakableWall = UnbreakableWall(positionX: 25, positionY: (screenHeight!) / 2 - 1075)
        addChild(unbreakableWall)
        unbreakableWall = UnbreakableWall(positionX: 75, positionY: (screenHeight!) / 2 - 1075)
        addChild(unbreakableWall)
        unbreakableWall = UnbreakableWall(positionX: 125, positionY: (screenHeight!) / 2 - 1075)
        addChild(unbreakableWall)
        unbreakableWall = UnbreakableWall(positionX: 175, positionY: (screenHeight!) / 2 - 1075)
        addChild(unbreakableWall)
        unbreakableWall = UnbreakableWall(positionX: 175, positionY: (screenHeight!) / 2 - 1125)
        addChild(unbreakableWall)
        unbreakableWall = UnbreakableWall(positionX: 175, positionY: (screenHeight!) / 2 - 1175)
        addChild(unbreakableWall)
        unbreakableWall = UnbreakableWall(positionX: 175, positionY: (screenHeight!) / 2 - 1225)
        addChild(unbreakableWall)
        unbreakableWall = UnbreakableWall(positionX: 175, positionY: (screenHeight!) / 2 - 1275)
        addChild(unbreakableWall)
        unbreakableWall = UnbreakableWall(positionX: 175, positionY: (screenHeight!) / 2 - 1325)
        addChild(unbreakableWall)
        // Unbreakable wall ends here ******
        // Base brick wall starts here ******
        var baseWall = BaseWall(positionX: -25, positionY: (screenHeight!) / 2 - 1225)
        baseWalls.append(baseWall)
        addChild(baseWall)
        baseWall = BaseWall(positionX: -25, positionY: (screenHeight!) / 2 - 1275)
        baseWalls.append(baseWall)
        addChild(baseWall)
        baseWall = BaseWall(positionX: -25, positionY: (screenHeight!) / 2 - 1325)
        baseWalls.append(baseWall)
        addChild(baseWall)
        baseWall = BaseWall(positionX: 25, positionY: (screenHeight!) / 2 - 1225)
        baseWalls.append(baseWall)
        addChild(baseWall)
        baseWall = BaseWall(positionX: 75, positionY: (screenHeight!) / 2 - 1225)
        baseWalls.append(baseWall)
        addChild(baseWall)
        baseWall = BaseWall(positionX: 125, positionY: (screenHeight!) / 2 - 1225)
        baseWalls.append(baseWall)
        addChild(baseWall)
        // Base brick wall ends here ******
    }
}
