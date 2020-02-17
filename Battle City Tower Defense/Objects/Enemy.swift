/*
 File Name: Enemy.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit

// The enemy GameObject class
class Enemy: GameObject
{
    // Instance members
    var currentWaypoint = 0;
    var state: String = "stopped"
    var stopOthers: Bool = false
    var tankDamage: Int = 0
    var tankHealth: Int = 999
    var tankSpeed: Double = 0.1
    var tankFireInterval: TimeInterval = 1
    var nextFireTime: Date?
    var targetLocation: CGPoint?
    var tankFinalWaypoint: CGPoint?
    var finalTargetPoint: CGPoint?
    var tanknumber: Int = -1
    
    // constructor
    init(imageString: String, finalWaypoint: CGPoint, damage: Int, fireInterval: TimeInterval, health: Int, speed: Double)
    {
        // If it's boss, make it bigger
        if (imageString == "redTankHeavy1"){
            super.init(imageString: imageString, initialScale: 5.0)
        }
        else{
            super.init(imageString: imageString, initialScale: 3.0)
        }
        // Assign different final waypoint to enemy tank
        tankFinalWaypoint = finalWaypoint
        finalTargetPoint = GameManager.basePosition
        tankDamage = damage
        tankHealth = health
        tankSpeed = speed
        Start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func Start()
    {
        self.position = CGPoint(x: 0, y: 600)
        self.zPosition = 2
    }
    
    override func Update()
    {
        var targetWaypoint = tankFinalWaypoint
        // Check if there is still a waypoint
        if (currentWaypoint < GameManager.waypoints.count){
            targetWaypoint = GameManager.waypoints[currentWaypoint]
        }
        // Calculates the distance between self and target waypoint
        let offset = CGPoint(x: targetWaypoint!.x - self.position.x, y: targetWaypoint!.y - self.position.y)
        let distance = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        // If the tank is moving
        if (state == "moving"){
            // If reached the target location
            if (distance <= 5){
                if (currentWaypoint < GameManager.waypoints.count - 1){
                    // If they waypoint is an attacking point, stop and fire
                    if (GameManager.isStoppingPoints[currentWaypoint]){
                        let lookAtConstraint = SKConstraint.orient(to: GameManager.targetPoints[currentWaypoint], offset: SKRange(constantValue: -CGFloat.pi / 2))
                        self.constraints = [ lookAtConstraint ]
                        nextFireTime = Date()
                        targetLocation = GameManager.targetPoints[currentWaypoint]
                        state = "firing"
                        stopOthers = true
                    }
                    // Otherwise stop and look for next waypoint
                    else{
                        currentWaypoint += 1;
                        state = "stopped"
                    }
                }
                // If at no more waypoint, stop
                else if (currentWaypoint == GameManager.waypoints.count - 1){
                    currentWaypoint += 1;
                    state = "stopped"
                }
                // If at the final waypoint, fire at base
                else{
                    if (currentWaypoint < GameManager.targetPoints.count){
                        let lookAtConstraint = SKConstraint.orient(to: GameManager.targetPoints[currentWaypoint], offset: SKRange(constantValue: -CGFloat.pi / 2))
                        self.constraints = [ lookAtConstraint ]
                        nextFireTime = Date()
                        targetLocation = GameManager.targetPoints[currentWaypoint]
                        state = "firing"
                    }
                    else {
                        let lookAtConstraint = SKConstraint.orient(to: finalTargetPoint!, offset: SKRange(constantValue: -CGFloat.pi / 2))
                        self.constraints = [ lookAtConstraint ]
                        nextFireTime = Date()
                        targetLocation = finalTargetPoint!
                        state = "firing"
                    }
                }
            }
        }
        // If stopped, look for next waypoint and move toward it
        else if (state == "stopped"){
            let duration = tankSpeed * distance / 10
            let move = SKAction.move(to: targetWaypoint!, duration: duration)
            self.run(move)
            // Rotation code from developer.apple.com
            if (distance > 5){
                let lookAtConstraint = SKConstraint.orient(to: targetWaypoint!, offset: SKRange(constantValue: -CGFloat.pi / 2))
                self.constraints = [ lookAtConstraint ]
            }
            state = "moving"
        }
        // If firing, shoot bullets at target
        else if (state == "firing"){
            let timeTilNextFire = nextFireTime!.timeIntervalSinceNow
            if (timeTilNextFire <= 0){
                fireBullet(target: targetLocation!)
                let timeNow = Date()
                nextFireTime = timeNow.addingTimeInterval(tankFireInterval)
            }
        // If paused, stay in place
        }else if (state == "paused"){
            self.removeAllActions()
        }
    }
    
    // Fires a bullet at target location
    func fireBullet(target: CGPoint){
        let bullet = Bullet(positionX: self.position.x, positionY: self.position.y, target: target, damage: tankDamage)
        let gameScene: GameScene = self.parent as! GameScene
        gameScene.enemyBullets.append(bullet)
        gameScene.addChild(bullet)
        let fireSound = SKAction.playSoundFileNamed("fire", waitForCompletion: false)
        gameScene.run(fireSound)
    }
    
    // Remove its own HP by certain amount
    func removeHp(hp: Int){
        tankHealth -= hp
    }
}
