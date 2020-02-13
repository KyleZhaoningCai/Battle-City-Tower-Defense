//
//  Tank.swift
//  Battle City Tower Defense
//
//  Created by Jason on 2020-02-11.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import SpriteKit

class Tank: GameObject
{
    
    var waypoints: [CGPoint] = []
    var isStoppingPoints: [Bool] = []
    var targetPoints: [CGPoint] = []
    var hasWallIndexToCheck: [Int] = []
    var currentWaypoint = 0;
    var state: String = "waiting"
    // "waiting" "firing"
    var stopOthers: Bool = false
    var tankDamage: Int = 0
    var tankHealth: Int = 999
    var tankSpeed: Double = 0.1
    var tankFireInterval: TimeInterval = 1
    var nextFireTime: Date?
    var targetLocation: CGPoint?
    
    var rangstate = "out"
    var tankstate = "waiting"
    var object1p = CGPoint(x: 1000, y: 1000)
    var object2p = CGPoint(x: 1000, y: 1000)
    
    var tankTarget: Int = 0
    var needtoremove = "n"
    
    
    // constructor
    init(imageString: String, damage: Int, fireInterval: TimeInterval)
    {
        super.init(imageString: imageString, initialScale: 1.5)
        isStoppingPoints.append(true)
        targetPoints.append(GameManager.basePosition)
        tankFireInterval = fireInterval
        tankDamage = damage
        nextFireTime = Date()
        Start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func Start()
    {
        self.position = CGPoint(x: 999, y: 999)
        self.zPosition = 2
        nextFireTime = Date()
    }
    
    override func Update()
    {
        let loading = nextFireTime!.timeIntervalSinceNow
        if (loading <= 0){
            if (tankstate == "firing") {
                nextFireTime = Date()
                let timeTilNextFire = nextFireTime!.timeIntervalSinceNow
                if (timeTilNextFire <= 0){
                    let lookAtConstraint = SKConstraint.orient(to: object1p, offset: SKRange(constantValue: -CGFloat.pi / 2))
                    self.constraints = [ lookAtConstraint ]
                    fireBullet(target1: object2p, target2: object1p)
                    let timeNow = Date()
                    nextFireTime = timeNow.addingTimeInterval(tankFireInterval)

                    
                }
            } else if (state == "firing") {
                
            }
        }
    }
    
    func fireBullet(target1: CGPoint, target2: CGPoint){
        if (nextFireTime!.timeIntervalSinceNow <= 0){
            let bullet = Bullet(positionX: target1.x, positionY: target1.y, target: target2, damage: tankDamage)
            let gameScene: GameScene = self.parent as! GameScene
            gameScene.enemyBullets.append(bullet)
            gameScene.addChild(bullet)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                bullet.removeFromParent()
            }
            let timeNow = Date()
            nextFireTime = timeNow.addingTimeInterval(tankFireInterval)
            let lookAtConstraint = SKConstraint.orient(to: object1p, offset: SKRange(constantValue: -CGFloat.pi / 2))
            self.constraints = [ lookAtConstraint ]
        }
    }
    
    
    
    func squaredDistance(point1: CGPoint, point2: CGPoint) -> CGFloat
    {
        let Xs: CGFloat = point2.x - point1.x
        let Ys: CGFloat = point2.y - point1.y
        return Xs * Xs + Ys * Ys
    }
    
    func squaredRadiusCheck(scene: SKScene, object1: GameObject, object2: GameObject) -> Void
    {
        
        let P1 = object1.position
        let P2 = object2.position
        let P1HalfHeight = object1.height! * 0.5
        let P2HalfHeight = object2.height! * 0.5
        let halfHeights = P1HalfHeight + P2HalfHeight
        
        if(squaredDistance(point1: P1, point2: P2) < (halfHeights * halfHeights + 150000))
        {
            rangstate = "in"
            tankstate = "firing"
            object1p = P1
            object2p = P2
        } else {
            rangstate = "out"
            tankstate = "waiting"
            object1p = P1
            object2p = P2
        }
        
    }
    

}
