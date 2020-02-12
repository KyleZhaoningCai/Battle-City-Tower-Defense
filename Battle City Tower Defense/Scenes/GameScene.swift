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
    
    var tankstyle: Int = 0
    
    var currentWave = 1
    var currentSpawn = 0
    var spawningEnemyTanks = false
    var startingNextWave = true
    var endTime: Date?
    var nextSpawnTime: Date?
    var enemyTanks: [Enemy] = []
    var tanks: [Tank] = []
    var brickWallPlaceholders: [BrickWallPlaceholder] = []
    var defTankPlaceholders: [DefTankPlaceHolder] = []
    var base: Base?
    var awaitingWallPlacement = false
    var enemyBullets: [Bullet] = []
    var currentWaypoint: Int = 99
    var brickWalls: [BrickWall] = []
    var baseWalls: [BaseWall] = []
    
    var enemycounter: Int = -1
    
    
    override func didMove(to view: SKView) {
        
        screenWidth = frame.width
        screenHeight = frame.height
        
        // Set up static tiles on the map
        setUpStaticTiles()
        // Set up brick wall placeholders
        setUpBrickWallPlaceholders()
        
        setDefTankPlaceholders()
        
        base = Base()
        addChild(base!)
        
        // *** to be changed later
        let tempButton = TempButton()
        addChild(tempButton)
        
        let deftank = DefTank()
        addChild(deftank)
        // ***
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = atPoint(pos)
        if touchedNode.name == "ylwTank-2"{
            for index in 0..<defTankPlaceholders.count{
                if !DefManager.hastankcheck[index]{
                    defTankPlaceholders[index].isHidden = false
                }
            }
        }
        if touchedNode.name == "hole"{
            
            for index in 0..<defTankPlaceholders.count{
                if defTankPlaceholders[index] == touchedNode{
                    DefManager.hastankcheck[index] = true
                    setDefTank(location: defTankPlaceholders[index].position, tankstyle: 1)
                    hidehole()
                    break
                }
            }
        }
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
        
        if tanks.count > 0 {
            if (tanks[0].state == "waiting") {
                for enemy in enemyTanks {
                    if tanks[0].rangstate == "in" {
                        tanks[0].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[0].tankTarget)], object2: tanks[0])
                        tanks[0].Update()
                    } else {
                        tanks[0].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[0])
                        tanks[0].tankTarget = enemy.tanknumber
                    }
                }
            }
            if tanks.count > 1 {
                if (tanks[1].state == "waiting") {
                    for enemy in enemyTanks {
                        if tanks[1].rangstate == "in" {
                            tanks[1].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[1].tankTarget)], object2: tanks[1])
                            tanks[1].Update()
                        } else {
                            tanks[1].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[1])
                            tanks[1].tankTarget = enemy.tanknumber
                        }
                    }
                }
                if tanks.count > 2 {
                    if (tanks[2].state == "waiting") {
                        for enemy in enemyTanks {
                            if tanks[2].rangstate == "in" {
                                tanks[2].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[2].tankTarget)], object2: tanks[2])
                                tanks[2].Update()
                            } else {
                                tanks[2].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[2])
                                tanks[2].tankTarget = enemy.tanknumber
                            }
                        }
                    }
                    if tanks.count > 3 {
                        if (tanks[3].state == "waiting") {
                            for enemy in enemyTanks {
                                if tanks[3].rangstate == "in" {
                                    tanks[3].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[3].tankTarget)], object2: tanks[3])
                                    tanks[3].Update()
                                } else {
                                    tanks[3].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[3])
                                    tanks[3].tankTarget = enemy.tanknumber
                                }
                            }
                        }
                        if tanks.count > 4 {
                            if (tanks[4].state == "waiting") {
                                for enemy in enemyTanks {
                                    if tanks[4].rangstate == "in" {
                                        tanks[4].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[4].tankTarget)], object2: tanks[4])
                                        tanks[4].Update()
                                    } else {
                                        tanks[4].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[4])
                                        tanks[4].tankTarget = enemy.tanknumber
                                    }
                                }
                            }
                            if tanks.count > 5 {
                                if (tanks[5].state == "waiting") {
                                    for enemy in enemyTanks {
                                        if tanks[5].rangstate == "in" {
                                            tanks[5].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[5].tankTarget)], object2: tanks[5])
                                            tanks[5].Update()
                                        } else {
                                            tanks[5].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[5])
                                            tanks[5].tankTarget = enemy.tanknumber
                                        }
                                    }
                                }
                                if tanks.count > 6 {
                                    if (tanks[6].state == "waiting") {
                                        for enemy in enemyTanks {
                                            if tanks[6].rangstate == "in" {
                                                tanks[6].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[6].tankTarget)], object2: tanks[6])
                                                tanks[6].Update()
                                            } else {
                                                tanks[6].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[6])
                                                tanks[6].tankTarget = enemy.tanknumber
                                            }
                                        }
                                    }
                                    if tanks.count > 7 {
                                        if (tanks[7].state == "waiting") {
                                            for enemy in enemyTanks {
                                                if tanks[7].rangstate == "in" {
                                                    tanks[7].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[7].tankTarget)], object2: tanks[7])
                                                    tanks[7].Update()
                                                } else {
                                                    tanks[7].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[7])
                                                    tanks[7].tankTarget = enemy.tanknumber
                                                }
                                            }
                                        }
                                        if tanks.count > 8 {
                                            if (tanks[8].state == "waiting") {
                                                for enemy in enemyTanks {
                                                    if tanks[8].rangstate == "in" {
                                                        tanks[8].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[8].tankTarget)], object2: tanks[8])
                                                        tanks[8].Update()
                                                    } else {
                                                        tanks[8].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[8])
                                                        tanks[8].tankTarget = enemy.tanknumber
                                                    }
                                                }
                                            }
                                            if tanks.count > 9 {
                                                if (tanks[9].state == "waiting") {
                                                    for enemy in enemyTanks {
                                                        if tanks[9].rangstate == "in" {
                                                            tanks[9].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[9].tankTarget)], object2: tanks[9])
                                                            tanks[9].Update()
                                                        } else {
                                                            tanks[9].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[9])
                                                            tanks[9].tankTarget = enemy.tanknumber
                                                        }
                                                    }
                                                }
                                                if tanks.count > 10 {
                                                    if (tanks[10].state == "waiting") {
                                                        for enemy in enemyTanks {
                                                            if tanks[10].rangstate == "in" {
                                                                tanks[10].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[10].tankTarget)], object2: tanks[10])
                                                                tanks[10].Update()
                                                            } else {
                                                                tanks[10].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[10])
                                                                tanks[10].tankTarget = enemy.tanknumber
                                                            }
                                                        }
                                                    }
                                                    if tanks.count > 11 {
                                                        if (tanks[11].state == "waiting") {
                                                            for enemy in enemyTanks {
                                                                if tanks[11].rangstate == "in" {
                                                                    tanks[11].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[11].tankTarget)], object2: tanks[11])
                                                                    tanks[11].Update()
                                                                } else {
                                                                    tanks[11].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[11])
                                                                    tanks[11].tankTarget = enemy.tanknumber
                                                                }
                                                            }
                                                        }
                                                        if tanks.count > 12 {
                                                            if (tanks[12].state == "waiting") {
                                                                for enemy in enemyTanks {
                                                                    if tanks[12].rangstate == "in" {
                                                                        tanks[12].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[12].tankTarget)], object2: tanks[12])
                                                                        tanks[12].Update()
                                                                    } else {
                                                                        tanks[12].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[12])
                                                                        tanks[12].tankTarget = enemy.tanknumber
                                                                    }
                                                                }
                                                            }
                                                            if tanks.count > 13 {
                                                                if (tanks[13].state == "waiting") {
                                                                    for enemy in enemyTanks {
                                                                        if tanks[13].rangstate == "in" {
                                                                            tanks[13].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[13].tankTarget)], object2: tanks[13])
                                                                            tanks[13].Update()
                                                                        } else {
                                                                            tanks[13].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[13])
                                                                            tanks[13].tankTarget = enemy.tanknumber
                                                                        }
                                                                    }
                                                                }
                                                                if tanks.count > 14 {
                                                                    if (tanks[14].state == "waiting") {
                                                                        for enemy in enemyTanks {
                                                                            if tanks[14].rangstate == "in" {
                                                                                tanks[14].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[14].tankTarget)], object2: tanks[14])
                                                                                tanks[14].Update()
                                                                            } else {
                                                                                tanks[14].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[14])
                                                                                tanks[14].tankTarget = enemy.tanknumber
                                                                            }
                                                                        }
                                                                    }
                                                                    if tanks.count > 15 {
                                                                        if (tanks[15].state == "waiting") {
                                                                            for enemy in enemyTanks {
                                                                                if tanks[15].rangstate == "in" {
                                                                                    tanks[15].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[15].tankTarget)], object2: tanks[15])
                                                                                    tanks[15].Update()
                                                                                } else {
                                                                                    tanks[15].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[15])
                                                                                    tanks[15].tankTarget = enemy.tanknumber
                                                                                }
                                                                            }
                                                                        }
                                                                        if tanks.count > 16 {
                                                                            if (tanks[16].state == "waiting") {
                                                                                for enemy in enemyTanks {
                                                                                    if tanks[16].rangstate == "in" {
                                                                                        tanks[16].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[16].tankTarget)], object2: tanks[16])
                                                                                        tanks[16].Update()
                                                                                    } else {
                                                                                        tanks[16].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[16])
                                                                                        tanks[16].tankTarget = enemy.tanknumber
                                                                                    }
                                                                                }
                                                                            }
                                                                            if tanks.count > 17 {
                                                                                if (tanks[17].state == "waiting") {
                                                                                    for enemy in enemyTanks {
                                                                                        if tanks[17].rangstate == "in" {
                                                                                            tanks[17].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[17].tankTarget)], object2: tanks[17])
                                                                                            tanks[17].Update()
                                                                                        } else {
                                                                                            tanks[17].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[17])
                                                                                            tanks[17].tankTarget = enemy.tanknumber
                                                                                        }
                                                                                    }
                                                                                }
                                                                                if tanks.count > 18 {
                                                                                    if (tanks[18].state == "waiting") {
                                                                                        for enemy in enemyTanks {
                                                                                            if tanks[18].rangstate == "in" {
                                                                                                tanks[18].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[18].tankTarget)], object2: tanks[18])
                                                                                                tanks[18].Update()
                                                                                            } else {
                                                                                                tanks[18].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[18])
                                                                                                tanks[18].tankTarget = enemy.tanknumber
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    if tanks.count > 19 {
                                                                                        if (tanks[19].state == "waiting") {
                                                                                            for enemy in enemyTanks {
                                                                                                if tanks[19].rangstate == "in" {
                                                                                                    tanks[19].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[19].tankTarget)], object2: tanks[19])
                                                                                                    tanks[19].Update()
                                                                                                } else {
                                                                                                    tanks[19].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[19])
                                                                                                    tanks[19].tankTarget = enemy.tanknumber
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        if tanks.count > 20 {
                                                                                            if (tanks[20].state == "waiting") {
                                                                                                for enemy in enemyTanks {
                                                                                                    if tanks[20].rangstate == "in" {
                                                                                                        tanks[20].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[20].tankTarget)], object2: tanks[20])
                                                                                                        tanks[20].Update()
                                                                                                    } else {
                                                                                                        tanks[20].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[20])
                                                                                                        tanks[20].tankTarget = enemy.tanknumber
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                            if tanks.count > 21 {
                                                                                                if (tanks[21].state == "waiting") {
                                                                                                    for enemy in enemyTanks {
                                                                                                        if tanks[21].rangstate == "in" {
                                                                                                            tanks[21].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[21].tankTarget)], object2: tanks[21])
                                                                                                            tanks[21].Update()
                                                                                                        } else {
                                                                                                            tanks[21].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[21])
                                                                                                            tanks[21].tankTarget = enemy.tanknumber
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                if tanks.count > 22 {
                                                                                                    if (tanks[22].state == "waiting") {
                                                                                                        for enemy in enemyTanks {
                                                                                                            if tanks[22].rangstate == "in" {
                                                                                                                tanks[22].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[22].tankTarget)], object2: tanks[22])
                                                                                                                tanks[22].Update()
                                                                                                            } else {
                                                                                                                tanks[22].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[22])
                                                                                                                tanks[22].tankTarget = enemy.tanknumber
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                    if tanks.count > 23 {
                                                                                                        if (tanks[23].state == "waiting") {
                                                                                                            for enemy in enemyTanks {
                                                                                                                if tanks[23].rangstate == "in" {
                                                                                                                    tanks[23].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[23].tankTarget)], object2: tanks[23])
                                                                                                                    tanks[23].Update()
                                                                                                                } else {
                                                                                                                    tanks[23].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[23])
                                                                                                                    tanks[23].tankTarget = enemy.tanknumber
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                        if tanks.count > 24 {
                                                                                                            if (tanks[24].state == "waiting") {
                                                                                                                for enemy in enemyTanks {
                                                                                                                    if tanks[24].rangstate == "in" {
                                                                                                                        tanks[24].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[24].tankTarget)], object2: tanks[24])
                                                                                                                        tanks[24].Update()
                                                                                                                    } else {
                                                                                                                        tanks[24].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[24])
                                                                                                                        tanks[24].tankTarget = enemy.tanknumber
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                            if tanks.count > 25 {
                                                                                                                if (tanks[25].state == "waiting") {
                                                                                                                    for enemy in enemyTanks {
                                                                                                                        if tanks[25].rangstate == "in" {
                                                                                                                            tanks[25].squaredRadiusCheck(scene: self, object1: enemyTanks[(tanks[25].tankTarget)], object2: tanks[25])
                                                                                                                            tanks[25].Update()
                                                                                                                        } else {
                                                                                                                            tanks[25].squaredRadiusCheck(scene: self, object1: enemy, object2: tanks[25])
                                                                                                                            tanks[25].tankTarget = enemy.tanknumber
                                                                                                                        }
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            
            
            
            
        }
        

        
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
                    enemycounter = -1
                }
            }
        }
        if (spawningEnemyTanks){
            switch (currentWave){
            case 1:
                if (currentSpawn < numberOfEnemy){
                    let remainingSeconds = Int(nextSpawnTime!.timeIntervalSinceNow)
                    if (remainingSeconds <= 0){
                        let enemy = Enemy(imageString: "silverTank-1", finalWaypoint: finalWaypoints[currentSpawn], damage: 10, fireInterval: 0.01, health: 20, speed: 0.1)
                        addChild(enemy)
                        
                        enemycounter = enemycounter + 1
                        enemy.tanknumber = enemycounter
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
    
    
    func setDefTankPlaceholders(){
        var defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[0].x, positionY: DefManager.tankLocations[0].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[1].x, positionY: DefManager.tankLocations[1].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[2].x, positionY: DefManager.tankLocations[2].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[3].x, positionY: DefManager.tankLocations[3].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[4].x, positionY: DefManager.tankLocations[4].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[5].x, positionY: DefManager.tankLocations[5].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[6].x, positionY: DefManager.tankLocations[6].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[7].x, positionY: DefManager.tankLocations[7].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[8].x, positionY: DefManager.tankLocations[8].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[9].x, positionY: DefManager.tankLocations[9].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[10].x, positionY: DefManager.tankLocations[10].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[11].x, positionY: DefManager.tankLocations[11].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[12].x, positionY: DefManager.tankLocations[12].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[13].x, positionY: DefManager.tankLocations[13].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[14].x, positionY: DefManager.tankLocations[14].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[15].x, positionY: DefManager.tankLocations[15].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[16].x, positionY: DefManager.tankLocations[16].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[17].x, positionY: DefManager.tankLocations[17].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[18].x, positionY: DefManager.tankLocations[18].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[19].x, positionY: DefManager.tankLocations[19].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[20].x, positionY: DefManager.tankLocations[20].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[21].x, positionY: DefManager.tankLocations[21].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[22].x, positionY: DefManager.tankLocations[22].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[23].x, positionY: DefManager.tankLocations[23].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[24].x, positionY: DefManager.tankLocations[24].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)
        defTankPlaceholder = DefTankPlaceHolder(positionX: DefManager.tankLocations[25].x, positionY: DefManager.tankLocations[25].y)
        defTankPlaceholder.isHidden = true
        addChild(defTankPlaceholder)
        defTankPlaceholders.append(defTankPlaceholder)        
    }
    
    func setDefTank (location: CGPoint, tankstyle: Int) {
        switch (tankstyle){
        case 1:
            let tank = Tank(imageString: "ylwTank-1", damage: 10, fireInterval: 1)
            tank.position = location
            addChild(tank)
            tanks.append(tank)
            break;
        default:
            break;
        }
    }
    
    func hidehole () {
        for dtph in defTankPlaceholders{
            dtph.isHidden = true}
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
