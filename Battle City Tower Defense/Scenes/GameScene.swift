/*
 File Name: GameScene.swift
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

let screenSize = UIScreen.main.bounds
var screenWidth: CGFloat?
var screenHeight: CGFloat?
let basewallHP = SKLabelNode(text: "BaseWallHP:100")

//let basewallHP = SKLabelNode(text: "BaseWallHP:100")
let Coins = SKLabelNode(text: "Coins:0")
let Tank1 = SKLabelNode(text: "100")
let Tank2 = SKLabelNode(text: "200")
let Tank3 = SKLabelNode(text: "300")
let Tank4 = SKLabelNode(text: "400")
let wall = SKLabelNode(text: "300")
let msg = SKLabelNode(text: "")
let timer = SKLabelNode(text: "")


// The main game scene
class GameScene: SKScene {
    
    // Instance members
    let waveInterval: Double = 22.5
    let bonusInterval: Double = 30	
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
    let cheatSequence: String = "HWWWHHWH"
    
    var nextBonueTime = Date()
    var cheatActivated: Bool = false
    var msgVanishTime = Date()
    var currentWave = 1
    var currentSpawn = 0
    var spawningEnemyTanks = false
    var startingNextWave = true
    var endTime: Date?
    var nextSpawnTime: Date?
    var enemyTanks: [Enemy] = []
    var tanks: [Tank] = []
    var booms:[BOOM] = []
    var brickWallPlaceholders: [BrickWallPlaceholder] = []
    var defTankPlaceholders: [DefTankPlaceHolder] = []
    var base: Base?
    var playerAction: String = ""
    var enemyBullets: [Bullet] = []
    var deftankBullets: [DefBullet] = []
    var currentWaypoint: Int = 99
    var brickWalls: [BrickWall] = []
    var baseWalls: [BaseWall] = []
    var cheatString: String = ""
    var waypointsFinalized = false
    var player: Player?
    var backgroundMusicPlayer: AVAudioPlayer?
    var enteringEndScene: Bool = false
    var enterEndSceneTime: Date = Date()
    var enemycounter: Int = -1
    var coinBag: CoinBag?
    
    // Set up various GameObjects and background music
    override func didMove(to view: SKView) {
        
        screenWidth = frame.width
        screenHeight = frame.height
        
        player = Player()
        addChild(player!)
        
        // Set up static tiles on the map
        setUpStaticTiles()
        // Set up brick wall placeholders
        setUpBrickWallPlaceholders()
        
        setDefTankPlaceholders()
        
        base = Base()
        addChild(base!)
        
        let leftButton1 = LeftButtonOne()
        addChild(leftButton1)
        
        let leftButton2 = LeftButtonTwo()
        addChild(leftButton2)
        
        let leftButton3 = LeftButtonThree()
        addChild(leftButton3)
        
        let leftButton4 = LeftButtonFour()
        addChild(leftButton4)
        
        let hammer = Hammer()
        addChild(hammer)
        
        let brickWall = Wall()
        addChild(brickWall)
        
        
        basewallHP.fontSize = 36
        basewallHP.fontColor = SKColor.white
        basewallHP.fontName = "SHPinscher-Regular"
        basewallHP.numberOfLines = 0
        basewallHP.preferredMaxLayoutWidth = 120
        
        basewallHP.position = CGPoint(x:-205, y:530)
        addChild(basewallHP)
        
        
        Coins.fontSize = 36
        Coins.fontColor = SKColor.white
        Coins.fontName = "SHPinscher-Regular"
        Coins.position = CGPoint(x:190, y:560)
        addChild(Coins)
        
        Tank1.fontSize = 25
        Tank1.fontColor = SKColor.white
        Tank1.fontName = "SHPinscher-Regular"
        Tank1.position = CGPoint(x: -290, y: -400)
        addChild(Tank1)
        
        Tank2.fontSize = 25
        Tank2.fontColor = SKColor.white
        Tank2.fontName = "SHPinscher-Regular"
        Tank2.position = CGPoint(x: -290, y: -470)
        addChild(Tank2)
        
        
        
        Tank3.fontSize = 25
        Tank3.fontColor = SKColor.white
        Tank3.fontName = "SHPinscher-Regular"
        Tank3.position = CGPoint(x: -290, y: -540)
        addChild(Tank3)
        
        
        Tank4.fontSize = 25
        Tank4.fontColor = SKColor.white
        Tank4.fontName = "SHPinscher-Regular"
        Tank4.position = CGPoint(x: -290, y: -610)
        addChild(Tank4)
        
        wall.fontSize = 25
        wall.fontColor = SKColor.white
        wall.fontName = "SHPinscher-Regular"
        wall.position = CGPoint(x: 290, y: -505)
        addChild(wall)
        
        msg.fontSize = 46
        msg.fontColor = SKColor.white
        msg.fontName = "SHPinscher-Regular"
        msg.position = CGPoint(x: 0, y: 350)
        msg.zPosition = 15
        addChild(msg)
        
        timer.fontSize = 46
        timer.fontColor = SKColor.white
        timer.fontName = "SHPinscher-Regular"
        timer.position = CGPoint(x: 0, y: 400)
        timer.zPosition = 15
        addChild(timer)
        // ***
        
        nextBonueTime = Date().addingTimeInterval(bonusInterval)
        
        // preload sounds
        do {
            let path: String = Bundle.main.path(forResource: "GameBackground", ofType: "mp3")!
            let url: URL = URL(fileURLWithPath: path)
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.play()
        } catch {
        }
    }
    
    // Check what GameObject the player touched
    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = atPoint(pos)
        // If the player touched one of the tank buttons, turn on tank location placeholders
        if touchedNode.name == "tankBTN1"{
            cheatStringUpdate(character: "T")
            if (playerAction == "makeTank1"){
                playerAction = ""
                turnOffDefTankPlaceholders()
            }else{
                playerAction = "makeTank1"
                turnOnDefTankPlaceholders()
                turnOffBrickWallPlaceholders()
            }
        }
        if touchedNode.name == "tankBTN2"{
            cheatStringUpdate(character: "T")
            if (playerAction == "makeTank2"){
                playerAction = ""
                turnOffDefTankPlaceholders()
            }else{
                playerAction = "makeTank2"
                turnOnDefTankPlaceholders()
                turnOffBrickWallPlaceholders()
            }
        }
        if touchedNode.name == "tankBTN3"{
            cheatStringUpdate(character: "T")
            if (playerAction == "makeTank3"){
                playerAction = ""
                turnOffDefTankPlaceholders()
            }else{
                playerAction = "makeTank3"
                turnOnDefTankPlaceholders()
                turnOffBrickWallPlaceholders()
            }
        }
        if touchedNode.name == "TankBTN4"{
            cheatStringUpdate(character: "T")
            if (playerAction == "makeTank4"){
                playerAction = ""
                turnOffDefTankPlaceholders()
            }else{
                playerAction = "makeTank4"
                turnOnDefTankPlaceholders()
                turnOffBrickWallPlaceholders()
            }
        }
        // If player touched a tank placeholder, order the player aircraft to place a tank
        if touchedNode.name == "hole"{
            cheatStringUpdate(character: "P")
            for index in 0..<defTankPlaceholders.count{
                if defTankPlaceholders[index] == touchedNode{
                    player?.currentTask = playerAction
                    player?.itemIndex = index
                    player?.targetLocation = defTankPlaceholders[index].position
                    player?.Move()
                    playerAction = ""
                    turnOffDefTankPlaceholders()
                    break
                }
            }
        }
        // If player touched the wall button, turn on all wall placeholders
        if touchedNode.name == "wallBtn"{
            cheatStringUpdate(character: "W")
            if (!spawningEnemyTanks){
                if (playerAction == "makeWall"){
                    playerAction = ""
                    turnOffBrickWallPlaceholders()
                }else{
                    playerAction = "makeWall"
                    turnOnBrickWallPlaceholders()
                    turnOffDefTankPlaceholders()
                }
            }
            // Do not allow player to place a wall when enemies are in the scene
            else{
                setMsg(msgContent: "Can't place wall now")
            }
        }
        // If the player touched the hammer butotn
        if touchedNode.name == "hammerbutton"{
            cheatStringUpdate(character: "H")
            turnOffDefTankPlaceholders()
            turnOffBrickWallPlaceholders()
            if (playerAction == "hammerDown"){
                playerAction = ""
            }else{
                playerAction = "hammerDown"
                setMsg(msgContent: "Hammer selected")
            }
        }
        // If player just touched hammer button before this, destroy player placed wall
        if touchedNode.name == "largeBrickWall"{
            cheatStringUpdate(character: "B")
            if (playerAction == "hammerDown"){
                for index in 0..<brickWalls.count{
                    if brickWalls[index] == touchedNode{
                        player?.currentTask = "destroyWall"
                        player?.itemIndex = index
                        player?.targetLocation = brickWalls[index].position
                        player?.Move()
                        playerAction = ""
                        break
                    }
                }
            }
        }
        // If player touched wall placeholder, order the player aircraft to place a wall
        if touchedNode.name == "placeholder"{
            cheatStringUpdate(character: "P")
            for index in 0..<brickWallPlaceholders.count{
                if brickWallPlaceholders[index] == touchedNode{
                    player?.currentTask = "wall"
                    player?.itemIndex = index
                    player?.targetLocation = brickWallPlaceholders[index].position
                    player?.Move()
                    playerAction = ""
                    turnOffBrickWallPlaceholders()
                    break
                }
            }
        }
        // If player just touched hammer button before this, destroy defending tank
        if (touchedNode.name == "ylwTank-1" || touchedNode.name == "ylwTank-2" || touchedNode.name == "ylwTank-3" || touchedNode.name == "ylwTank-4"){
            cheatStringUpdate(character: "D")
            if (playerAction == "hammerDown"){
                for index in 0..<tanks.count{
                    if tanks[index] == touchedNode{
                        player?.currentTask = "destroyTank"
                        player?.itemIndex = index
                        player?.targetLocation = tanks[index].position
                        player?.Move()
                        playerAction = ""
                        break
                    }
                }
            }
        }
        // If player touched coin bag, award player with 500 coins
        if (touchedNode.name == "coinBag"){
            touchedNode.removeFromParent()
            let coinSound = SKAction.playSoundFileNamed("coin", waitForCompletion: false)
            run(coinSound)
            GameManager.playerCoin += 500
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self))  }
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
    
    // The update function
    override func update(_ currentTime: TimeInterval) {
        
        // If there are defending tanks, check if enemy tanks are in firing range
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
        
        // If starting next wave, start next wave count down
        if (startingNextWave){
            startingNextWave = false
            let timeNow = Date()
            endTime = timeNow.addingTimeInterval(waveInterval)
        }
        else{
            // If wave already started, and enemies are not spawnning yet, counting down
            if (!spawningEnemyTanks){
                let remainingSeconds = Int(endTime!.timeIntervalSinceNow)
                timer.text = "Next wave in " + String(remainingSeconds) + " seconds"
                if (remainingSeconds <= 0){
                    timer.text = ""
                    spawningEnemyTanks = true
                    enemyTanks = []
                    currentSpawn = 0
                    nextSpawnTime = Date()
                    turnOffBrickWallPlaceholders()
                    player?.clearAction()
                    enemycounter = -1
                }
            }
        }
        // If spawnning enemy tanks
        if (spawningEnemyTanks){
            // If not finalized, populate all waypoints
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
            
            // Spawn different enemies in different wave
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
                        let enemy = Enemy(imageString: "redTankHeavy1", finalWaypoint: finalWaypoints[currentSpawn], damage: 500, fireInterval: 0.2, health: 1000, speed: 0.4)
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
        // If there are enemy tanks
        if (enemyTanks.count > 0){
            var stoppingOthers = false
            for tank in enemyTanks
            {
                // If a leading tank is firing, stop other tanks
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
            // If spawnning enemy tanks, spawn a tank every 2 seconds
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
        // If there are enemy bullets, check their collision with various GameObjects
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
        // If there are enemy tanks and defending tank bullets, check their collision
        if (enemyTanks.count > 0 && deftankBullets.count > 0) {
            for tankBullet in deftankBullets {
                for enemytank in enemyTanks {
                    DefTankAtkManager.squaredRadiusCheck(scene: self, object1: tankBullet, object2: enemytank)
                }
            }
        }
        // If the player has a task, check if the player aircraft has reached its target
        // When reached, completes its action
        if (player?.currentTask != ""){
            if (player?.getDistance())! < 5{
                if (player?.currentTask == "wall"){
                    if (GameManager.playerCoin >= 300){
                        GameManager.hasWallCheck[(player?.itemIndex)!] = true
                        brickWallPlaceholders[(player?.itemIndex)!].isHidden = true
                        spawnBrickWall(location: brickWallPlaceholders[(player?.itemIndex)!].position, index: (player?.itemIndex)!)
                        GameManager.playerCoin -= 300
                    }else{
                        setMsg(msgContent: "Not enough coins")
                    }
                    player?.clearAction()
                }
                else if (player?.currentTask == "makeTank1" || player?.currentTask == "makeTank2" || player?.currentTask == "makeTank3" || player?.currentTask == "makeTank4"){
                    if (player?.currentTask == "makeTank1" && GameManager.playerCoin >= 100){
                        setDefTank(location: defTankPlaceholders[(player?.itemIndex)!].position, tankstyle: 1)
                        for index in 0..<DefManager.tankLocations.count{
                            if DefManager.tankLocations[index] == defTankPlaceholders[(player?.itemIndex)!].position{
                                DefManager.hastankcheck[index] = true
                                defTankPlaceholders[(player?.itemIndex)!].isHidden = true
                                break
                            }
                        }
                        GameManager.playerCoin -= 100
                    }
                    else if (player?.currentTask == "makeTank2" && GameManager.playerCoin >= 200){
                        setDefTank(location: defTankPlaceholders[(player?.itemIndex)!].position, tankstyle: 2)
                        for index in 0..<DefManager.tankLocations.count{
                            if DefManager.tankLocations[index] == defTankPlaceholders[(player?.itemIndex)!].position{
                                DefManager.hastankcheck[index] = true
                                defTankPlaceholders[(player?.itemIndex)!].isHidden = true
                                break
                            }
                        }
                        GameManager.playerCoin -= 200
                    }
                    else if (player?.currentTask == "makeTank3" && GameManager.playerCoin >= 300){
                        setDefTank(location: defTankPlaceholders[(player?.itemIndex)!].position, tankstyle: 3)
                        for index in 0..<DefManager.tankLocations.count{
                            if DefManager.tankLocations[index] == defTankPlaceholders[(player?.itemIndex)!].position{
                                DefManager.hastankcheck[index] = true
                                defTankPlaceholders[(player?.itemIndex)!].isHidden = true
                                break
                            }
                        }
                        GameManager.playerCoin -= 300
                    }
                    else if (player?.currentTask == "makeTank4" && GameManager.playerCoin >= 400){
                        setDefTank(location: defTankPlaceholders[(player?.itemIndex)!].position, tankstyle: 4)
                        for index in 0..<DefManager.tankLocations.count{
                            if DefManager.tankLocations[index] == defTankPlaceholders[(player?.itemIndex)!].position{
                                DefManager.hastankcheck[index] = true
                                defTankPlaceholders[(player?.itemIndex)!].isHidden = true
                                break
                            }
                        }
                        GameManager.playerCoin -= 400
                    }
                    else{
                        setMsg(msgContent: "Not enough coins")
                    }
                    player?.clearAction()
                }
                else if (player?.currentTask == "destroyWall"){
                    let wallToRemove = brickWalls[player!.itemIndex]
                    for index in 0..<GameManager.wallLocations.count{
                        if GameManager.wallLocations[index] == wallToRemove.position{
                            GameManager.hasWallCheck[index] = false
                        }
                    }
                    for index in 0..<enemyTanks.count{
                        enemyTanks[index].stopOthers = false
                        enemyTanks[index].state = "stopped"
                        for i in 0..<GameManager.targetPoints.count{
                            if wallToRemove.position == GameManager.targetPoints[i]{
                                GameManager.isStoppingPoints[i] = false
                            }
                        }
                    }
                    brickWalls.remove(at: player!.itemIndex)
                    wallToRemove.removeFromParent()
                    let destroyWallSound = SKAction.playSoundFileNamed("destroy", waitForCompletion: false)
                    run(destroyWallSound)
                    player?.clearAction()
                }
                else if (player?.currentTask == "destroyTank"){
                    let tankToRemove = tanks[player!.itemIndex]
                    tanks.remove(at: player!.itemIndex)
                    for index in 0..<DefManager.tankLocations.count{
                        if DefManager.tankLocations[index] == tankToRemove.position{
                            DefManager.hastankcheck[index] = false
                            break
                        }
                    }
                    tankToRemove.removeFromParent()
                    let destroyWallSound = SKAction.playSoundFileNamed("destroy", waitForCompletion: false)
                    run(destroyWallSound)
                    player?.clearAction()
                }
            }
        }
        // Every 30 seconds, spawn a coin bag that flies across the screen
        if (nextBonueTime.timeIntervalSinceNow <= 0){
            let sideFactor = Int.random(in: 0...3)
            if (sideFactor == 0 || sideFactor == 1){
                let xLeft = -370
                let yLeft = Int.random(in: -500...500)
                let xRight = 370
                let yRight = Int.random(in: -500...500)
                if (sideFactor == 0){
                  coinBag = CoinBag(spawnLocation: CGPoint(x: xLeft, y: yLeft), targetLocation: CGPoint(x: xRight, y: yRight))
                }
                else{
                    coinBag = CoinBag(spawnLocation: CGPoint(x: xRight, y: yRight), targetLocation: CGPoint(x: xLeft, y: yLeft))
                }
            }
            else if (sideFactor == 2 || sideFactor == 3){
                let xTop = Int.random(in: -250...250)
                let yTop = 730
                let xBot = Int.random(in: -250...250)
                let yBot = -730
                if (sideFactor == 2){
                    coinBag = CoinBag(spawnLocation: CGPoint(x: xTop, y: yTop), targetLocation: CGPoint(x: xBot, y: yBot))
                }
                else{
                    coinBag = CoinBag(spawnLocation: CGPoint(x: xBot, y: yBot), targetLocation: CGPoint(x: xTop, y: yTop))
                }
            }
            addChild(coinBag!)
            nextBonueTime = Date().addingTimeInterval(bonusInterval)
        }
        // If msg is not empty, make it vanish after 3 seconds
        if (msg.text != ""){
            if msgVanishTime.timeIntervalSinceNow <= 0{
                msg.text = ""
            }
        }
        // If the cheat sequence matches the player button press order, give player 9999 coins one time
        if (cheatSequence == cheatString && !cheatActivated){
            GameManager.playerCoin += 9999
            cheatString = ""
            cheatActivated = true
        }
        // Update base wall hp and coin labels
        Coins.text = "Coins:" + String(GameManager.playerCoin)
        basewallHP.text = "Base Wall HP:" + String(GameManager.baseHp)
        if (GameManager.gameState != "onGoing" && !enteringEndScene){
            enteringEndScene = true
            enterEndSceneTime = Date().addingTimeInterval(5)
        }
        // If game is over or won, go to EndScene
        if (enteringEndScene && enterEndSceneTime.timeIntervalSinceNow <= 0){
            enteringEndScene = false
            let scene:SKScene = SKScene(fileNamed: "EndScene")!
            scene.scaleMode = .aspectFill
            self.view!.presentScene(scene)
            self.removeAllActions()
            self.removeAllChildren()
            backgroundMusicPlayer?.stop()
        }
    }
    
    // The the message of msg label
    func setMsg(msgContent: String){
        msg.text = msgContent
        msgVanishTime = Date().addingTimeInterval(3)
    }
    
    // Build a brick wall at player pressed location
    func spawnBrickWall(location: CGPoint, index: Int){
        let brickWall = BrickWall(positionX: location.x, positionY: location.y, checkWallIndex: index)
        brickWalls.append(brickWall)
        addChild(brickWall)
    }
    
    // Turn on all brick wall placeholders
    func turnOnBrickWallPlaceholders(){
        for index in 0..<brickWallPlaceholders.count{
            if !GameManager.hasWallCheck[index]{
                brickWallPlaceholders[index].isHidden = false
            }
        }
    }
    
    // Turn off all brick wall placeholders
    func turnOffBrickWallPlaceholders(){
        for brickWallPlaceholder in brickWallPlaceholders{
            brickWallPlaceholder.isHidden = true
            
        }
    }
    
    // Update the player press button order
    func cheatStringUpdate(character: String){
        if (cheatString.count >= 8){
            cheatString = String(cheatString.suffix(7))
        }
        cheatString = cheatString + character
    }
    
    // Turn on all defending tank placehoders
    func turnOnDefTankPlaceholders(){
        for index in 0..<defTankPlaceholders.count{
            if !DefManager.hastankcheck[index]{
                defTankPlaceholders[index].isHidden = false
            }
        }
    }
    
    // Turn off all defending tank placehoders
    func turnOffDefTankPlaceholders(){
        for defTankPlaceHolder in defTankPlaceholders{
            defTankPlaceHolder.isHidden = true
        }
    }
    
    // Set up all wall placeholders
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
    
    // Set up all defending tank placeholders
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
    
    // Set a defending tank at player pressed location
    func setDefTank (location: CGPoint, tankstyle: Int) {
        switch (tankstyle){
        case 1:
            let tank = Tank(imageString: "ylwTank-1", damage: 1, fireInterval: 0.5)
            tank.position = location
            addChild(tank)
            tanks.append(tank)
            break;
        case 2:
            let tank = Tank(imageString: "ylwTank-2", damage: 2, fireInterval: 1)
            tank.position = location
            addChild(tank)
            tanks.append(tank)
            break;
        case 3:
            let tank = Tank(imageString: "ylwTank-3", damage: 5, fireInterval: 1.5)
            tank.position = location
            addChild(tank)
            tanks.append(tank)
            break;
        case 4:
            let tank = Tank(imageString: "ylwTank-4", damage: 10, fireInterval: 1.5)
            tank.position = location
            addChild(tank)
            tanks.append(tank)
            break;
        default:
            break;
        }
    }
    
    // Set up all static GameObjects
    func setUpStaticTiles(){
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
        river = River(positionX: -25, positionY: (screenHeight!) / 2 - 1075)
        addChild(river)
        river = River(positionX: 25, positionY: (screenHeight!) / 2 - 1075)
        addChild(river)
        river = River(positionX: 75, positionY: (screenHeight!) / 2 - 1075)
        addChild(river)
        river = River(positionX: 125, positionY: (screenHeight!) / 2 - 1075)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 1075)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 1125)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 1175)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 1225)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 1275)
        addChild(river)
        river = River(positionX: 175, positionY: (screenHeight!) / 2 - 1325)
        addChild(river)
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

