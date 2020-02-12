import SpriteKit

class Enemy: GameObject
{
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
    
    // constructor
    init(imageString: String, finalWaypoint: CGPoint, damage: Int, fireInterval: TimeInterval, health: Int, speed: Double)
    {
        if (imageString == "redTankHeavy1"){
            super.init(imageString: imageString, initialScale: 5.0)
        }
        else{
            super.init(imageString: imageString, initialScale: 3.0)
        }
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
        if (currentWaypoint < GameManager.waypoints.count){
            targetWaypoint = GameManager.waypoints[currentWaypoint]

        }
        let offset = CGPoint(x: targetWaypoint!.x - self.position.x, y: targetWaypoint!.y - self.position.y)
        let distance = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        if (state == "moving"){
            if (distance <= 5){
                if (currentWaypoint < GameManager.waypoints.count - 1){
                    if (GameManager.isStoppingPoints[currentWaypoint]){
                        let lookAtConstraint = SKConstraint.orient(to: GameManager.targetPoints[currentWaypoint], offset: SKRange(constantValue: -CGFloat.pi / 2))
                        self.constraints = [ lookAtConstraint ]
                        nextFireTime = Date()
                        targetLocation = GameManager.targetPoints[currentWaypoint]
                        state = "firing"
                        stopOthers = true
                    }
                    else{
                        currentWaypoint += 1;
                        state = "stopped"
                    }
                }
                else if (currentWaypoint == GameManager.waypoints.count - 1){
                    currentWaypoint += 1;
                    state = "stopped"
                }
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
        else if (state == "stopped"){
            let duration = tankSpeed * distance / 10
            let move = SKAction.move(to: targetWaypoint!, duration: duration)
            self.run(move)
            // Rotation code from developer.apple.com
            if (self.position != targetWaypoint!){
                let lookAtConstraint = SKConstraint.orient(to: targetWaypoint!, offset: SKRange(constantValue: -CGFloat.pi / 2))
                self.constraints = [ lookAtConstraint ]
            }
            state = "moving"
        }
        else if (state == "firing"){
            let timeTilNextFire = nextFireTime!.timeIntervalSinceNow
            if (timeTilNextFire <= 0){
                fireBullet(target: targetLocation!)
                let timeNow = Date()
                nextFireTime = timeNow.addingTimeInterval(tankFireInterval)
            }
        }else if (state == "paused"){
            self.removeAllActions()
        }
    }
    
    func fireBullet(target: CGPoint){
        let bullet = Bullet(positionX: self.position.x, positionY: self.position.y, target: target, damage: tankDamage)
        let gameScene: GameScene = self.parent as! GameScene
        gameScene.enemyBullets.append(bullet)
        gameScene.addChild(bullet)
        let fireSound = SKAction.playSoundFileNamed("fire", waitForCompletion: false)
        gameScene.run(fireSound)
    }
    
    func removeHp(hp: Int){
        tankHealth -= hp
    }
}
