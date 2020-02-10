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
    
    override func didMove(to view: SKView) {
        
        screenWidth = frame.width
        screenHeight = frame.height
        
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
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = atPoint(pos)
        if touchedNode.name == "grass"{
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
            for index in 0..<brickWallPlaceholders.count{
                if brickWallPlaceholders[index] == touchedNode{
                    GameManager.hasWallCheck[index] = true
                    spawnBrickWall(location: brickWallPlaceholders[index].position, index: index)
                    break
                }
            }
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
                }
            }
        }
        if (spawningEnemyTanks){
            switch (currentWave){
                case 1:
                    if (currentSpawn < numberOfEnemy){
                        let remainingSeconds = Int(nextSpawnTime!.timeIntervalSinceNow)
                        if (remainingSeconds <= 0){
                            let enemy = Enemy(imageString: "silverTank-1", finalWaypoint: finalWaypoints[currentSpawn], damage: 10, fireInterval: 1, health: 20, speed: 0.1)
                            addChild(enemy)
                            enemyTanks.append(enemy)
                            currentSpawn += 1
                            let timeNow = Date()
                            nextSpawnTime = timeNow.addingTimeInterval(spawnInterval)
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
                            print(currentWaypoint)
                            tank.removeWaypoint(index: currentWaypoint)
                            tank.state = "stopped"
                        }
                    }
                }
                tank.Update()
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
