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
        
        
        if (tanks.count > 0){
            for tank in tanks{
                for enemy in enemyTanks{
                    tank.squaredRadiusCheck(scene: self, object1: enemy, object2: tank)
                    if (tank.rangstate == "in"){
                        tank.fireBullet(target1: tank.position, target2: enemy.position)
                    }
                }
            }
        }

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
                        let enemy = Enemy(imageString: "silverTank2", finalWaypoint: finalWaypoints[currentSpawn], damage: 10, fireInterval: 0.01, health: 20000, speed: 0.1)
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
                if (tanks.count > 0) {
                    for enemytank in enemyTanks {
                        CollisionManager.squaredRadiusCheck(scene: self, object1: enemyBullet, object2: enemytank)
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
            let tank = Tank(imageString: "ylwTank-1", damage: 10, fireInterval: 0.5)
            tank.position = location
            addChild(tank)
            tanks.append(tank)
            break;
        case 2:
            let tank = Tank(imageString: "ylwTank-1", damage: 20, fireInterval: 1)
            tank.position = location
            addChild(tank)
            tanks.append(tank)
            break;
        case 3:
            let tank = Tank(imageString: "ylwTank-1", damage: 50, fireInterval: 1.5)
            tank.position = location
            addChild(tank)
            tanks.append(tank)
            break;
        case 4:
            let tank = Tank(imageString: "ylwTank-1", damage: 100, fireInterval: 1.5)
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
