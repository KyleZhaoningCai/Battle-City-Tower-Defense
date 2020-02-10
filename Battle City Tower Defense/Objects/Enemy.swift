import SpriteKit

class Enemy: GameObject
{
    
    var waypoints: [CGPoint] = []
    var isStoppingPoints: [Bool] = []
    var targetPoints: [CGPoint] = []
    var hasWallIndexToCheck: [Int] = []
    var currentWaypoint = 0;
    var state: String = "stopped"
    var stopOthers: Bool = false
    var tankDamage: Int = 0
    var tankHealth: Int = 999
    var tankSpeed: Double = 0.1
    var tankFireInterval: TimeInterval = 1
    var nextFireTime: Date?
    var targetLocation: CGPoint?
    
    // constructor
    init(imageString: String, finalWaypoint: CGPoint, damage: Int, fireInterval: TimeInterval, health: Int, speed: Double)
    {
        super.init(imageString: imageString, initialScale: 3.0)
        waypoints.append(CGPoint(x: 0, y:  425))
        isStoppingPoints.append(false)
        targetPoints.append(CGPoint(x: 1000, y: 1000))
        waypoints.append(CGPoint(x: -100, y:  425))
        isStoppingPoints.append(false)
        targetPoints.append(CGPoint(x: 1000, y: 1000))
        waypoints.append(CGPoint(x: -100, y:  125))
        isStoppingPoints.append(false)
        targetPoints.append(CGPoint(x: 1000, y: 1000))
        waypoints.append(CGPoint(x: 100, y:  125))
        isStoppingPoints.append(false)
        targetPoints.append(CGPoint(x: 1000, y: 1000))
        if (GameManager.hasWallCheck[0]){
            waypoints.append(CGPoint(x: 100, y:  125))
            isStoppingPoints.append(true)
            targetPoints.append(GameManager.wallLocations[0])
            hasWallIndexToCheck.append(0)
        }
        if (GameManager.hasWallCheck[1]){
            waypoints.append(CGPoint(x: 100, y:  25))
            isStoppingPoints.append(true)
            targetPoints.append(GameManager.wallLocations[1])
            hasWallIndexToCheck.append(1)
        }
        waypoints.append(CGPoint(x: 100, y:  -175))
        isStoppingPoints.append(false)
        targetPoints.append(CGPoint(x: 1000, y: 1000))
        waypoints.append(CGPoint(x: -100, y:  -175))
        isStoppingPoints.append(false)
        targetPoints.append(CGPoint(x: 1000, y: 1000))
        waypoints.append(CGPoint(x: -100, y:  -475))
        isStoppingPoints.append(false)
        targetPoints.append(CGPoint(x: 1000, y: 1000))
        waypoints.append(finalWaypoint)
        isStoppingPoints.append(true)
        targetPoints.append(GameManager.basePosition)
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
        let targetWaypoint = waypoints[currentWaypoint]
        let offset = CGPoint(x: targetWaypoint.x - self.position.x, y: targetWaypoint.y - self.position.y)
        let distance = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        if (state == "moving"){
            if (distance <= 5){
                if (currentWaypoint < waypoints.count - 1){
                    if (isStoppingPoints[currentWaypoint]){
                        let lookAtConstraint = SKConstraint.orient(to: targetPoints[currentWaypoint], offset: SKRange(constantValue: -CGFloat.pi / 2))
                        self.constraints = [ lookAtConstraint ]
                        nextFireTime = Date()
                        targetLocation = targetPoints[currentWaypoint]
                        state = "firing"
                        stopOthers = true
                    }
                    else{
                        currentWaypoint += 1;
                        state = "stopped"
                    }
                }
                else{
                    let lookAtConstraint = SKConstraint.orient(to: targetPoints[currentWaypoint], offset: SKRange(constantValue: -CGFloat.pi / 2))
                    self.constraints = [ lookAtConstraint ]
                    nextFireTime = Date()
                    targetLocation = targetPoints[currentWaypoint]
                    state = "firing"
                }
            }
        }
        else if (state == "stopped"){
            let duration = tankSpeed * distance / 10
            let move = SKAction.move(to: targetWaypoint, duration: duration)
            self.run(move)
            // Rotation code from developer.apple.com
            let lookAtConstraint = SKConstraint.orient(to: targetWaypoint, offset: SKRange(constantValue: -CGFloat.pi / 2))
            self.constraints = [ lookAtConstraint ]
            state = "moving"
        }
        else if (state == "firing"){
            if (hasWallIndexToCheck.count == 0 || (hasWallIndexToCheck.count > 0 && GameManager.hasWallCheck[hasWallIndexToCheck[0]])){
                let timeTilNextFire = nextFireTime!.timeIntervalSinceNow
                if (timeTilNextFire <= 0){
                    fireBullet(target: targetLocation!)
                    let timeNow = Date()
                    nextFireTime = timeNow.addingTimeInterval(tankFireInterval)
                }
            }
            else if (hasWallIndexToCheck.count > 0 && !GameManager.hasWallCheck[hasWallIndexToCheck[0]]){
                removeWaypoint(index: currentWaypoint)
                state = "stopped"
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
    }
    
    func removeWaypoint(index: Int){
        waypoints.remove(at: index)
        isStoppingPoints.remove(at: index)
        targetPoints.remove(at: index)
        if (hasWallIndexToCheck.count > 0){
            hasWallIndexToCheck.remove(at: 0)
        }
    }
}
