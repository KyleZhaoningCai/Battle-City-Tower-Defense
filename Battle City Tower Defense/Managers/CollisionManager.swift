
import SpriteKit
import GameplayKit
import AVFoundation

class CollisionManager
{
    public static var gameViewController: GameViewController?
    
    public static func squaredDistance(point1: CGPoint, point2: CGPoint) -> CGFloat
    {
        let Xs: CGFloat = point2.x - point1.x
        let Ys: CGFloat = point2.y - point1.y
        
        return Xs * Xs + Ys * Ys
    }
    
    public static func squaredRadiusCheck(scene: SKScene, object1: GameObject, object2: GameObject) -> Void
    {
        let P1 = object1.position
        let P2 = object2.position
        let P1HalfHeight = object1.height! * 0.5
        let P2HalfHeight = object2.height! * 0.5
        let halfHeights = P1HalfHeight + P2HalfHeight
        
        if(squaredDistance(point1: P1, point2: P2) < (halfHeights * halfHeights))
        {
            switch object2.name {
            case "largeBrickWall":
                let hitWallSound = SKAction.playSoundFileNamed("wallHit", waitForCompletion: false)
                scene.run(hitWallSound)
                let hit: Hit = Hit(spawnLocation: P1)
                scene.addChild(hit)
                let brickWall: BrickWall = object2 as! BrickWall
                let bullet: Bullet = object1 as! Bullet
                let gameScene: GameScene = scene as! GameScene
                brickWall.reductHp(amount: bullet.power)
                var bulletRemoveIndex: Int?
                var wallRemoveIndex: Int?
                var wallToRemove: BrickWall?
                var removeBullet = false
                var removeWall = false
                for index in 0..<gameScene.enemyBullets.count{
                    if gameScene.enemyBullets[index] == bullet{
                        removeBullet = true
                        bulletRemoveIndex = index
                    }
                }
                if (brickWall.hp <= 0){
                    for index in 0..<gameScene.brickWalls.count{
                        if gameScene.brickWalls[index] == brickWall{
                            removeWall = true
                            wallRemoveIndex = index
                            wallToRemove = brickWall
                        }
                    }
                }
                if (removeBullet){
                    gameScene.enemyBullets.remove(at: bulletRemoveIndex!)
                    bullet.removeFromParent()
                }
                if (removeWall){
                    gameScene.brickWalls.remove(at: wallRemoveIndex!)
                    for index in 0..<GameManager.hasWallCheck.count{
                        if GameManager.wallLocations[index] == wallToRemove!.position{
                            GameManager.hasWallCheck[index] = false
                        }
                    }
                    GameManager.hasWallCheck[wallRemoveIndex!] = false
                    for index in 0..<gameScene.enemyTanks.count{
                        gameScene.enemyTanks[index].stopOthers = false
                        gameScene.enemyTanks[index].state = "stopped"
                        for i in 0..<GameManager.targetPoints.count{
                            if wallToRemove?.position == GameManager.targetPoints[i]{
                                GameManager.isStoppingPoints[i] = false
                            }
                        }
                    }
                    brickWall.removeFromParent()
                    let destroyWallSound = SKAction.playSoundFileNamed("destroy", waitForCompletion: false)
                    scene.run(destroyWallSound)
                }
                break
            case "brickWall":
                let hitWallSound = SKAction.playSoundFileNamed("wallHit", waitForCompletion: false)
                scene.run(hitWallSound)
                let hit: Hit = Hit(spawnLocation: P1)
                scene.addChild(hit)
                let bullet: Bullet = object1 as! Bullet
                let gameScene: GameScene = scene as! GameScene
                GameManager.baseHp -= bullet.power
                var bulletRemoveIndex: Int?
                var removeBullet = false
                var removeBaseWall = false
                for index in 0..<gameScene.enemyBullets.count{
                    if gameScene.enemyBullets[index] == bullet{
                        removeBullet = true
                        bulletRemoveIndex = index
                    }
                }
                if (GameManager.baseHp <= 0){
                    removeBaseWall = true
                }
                if (removeBullet){
                    gameScene.enemyBullets.remove(at: bulletRemoveIndex!)
                    bullet.removeFromParent()
                }
                if (removeBaseWall){
                    for baseWall in gameScene.baseWalls{
                        baseWall.removeFromParent()
                    }
                    gameScene.baseWalls = []
                    let destroyWallSound = SKAction.playSoundFileNamed("destroy", waitForCompletion: false)
                    scene.run(destroyWallSound)
                }
                break
            case "bird":
                let hitWallSound = SKAction.playSoundFileNamed("wallHit", waitForCompletion: false)
                scene.run(hitWallSound)
                let hit: Hit = Hit(spawnLocation: P1)
                scene.addChild(hit)
                let bullet: Bullet = object1 as! Bullet
                let gameScene: GameScene = scene as! GameScene
                var bulletRemoveIndex: Int?
                var removeBullet = false
                for index in 0..<gameScene.enemyBullets.count{
                    if gameScene.enemyBullets[index] == bullet{
                        removeBullet = true
                        bulletRemoveIndex = index
                    }
                }
                if (removeBullet){
                    gameScene.enemyBullets.remove(at: bulletRemoveIndex!)
                    bullet.removeFromParent()
                }
                let destroyWallSound = SKAction.playSoundFileNamed("destroy", waitForCompletion: false)
                scene.run(destroyWallSound)
                object2.removeFromParent()
                let destroyedBase: DestroyedBase = DestroyedBase()
                gameScene.addChild(destroyedBase)
                GameManager.gameState = "gameOver"
                break
            case "silverTank2",
                 "silverTankFast1",
                 "silverTankHeavy1",
                 "greenTank2",
                 "greenTankFast1",
                 "greenTankHeave1",
                 "redTank2",
                 "redTankHeavy1":
                if object1.position.y < -460 {
                    print("1")
                } else {
                    print("2")
                    let enemy: Enemy = object2 as! Enemy
                    let bullet: Bullet = object1 as! Bullet
                    let gameScene: GameScene = object2.parent as! GameScene
                    var bulletRemoveIndex: Int?
                    var tankRemoveIndex: Int?
                    var removeBullet = false
                    //var removeEnemy = false
                    for index in 0..<gameScene.enemyBullets.count{
                        if gameScene.enemyBullets[index] == bullet{
                            removeBullet = true
                            bulletRemoveIndex = index
                        }
                    }
                    for index in 0..<gameScene.enemyTanks.count{
                        if gameScene.enemyTanks[index] == enemy{
                            tankRemoveIndex = index
                        }
                    }
                    if (removeBullet){
                        gameScene.enemyBullets.remove(at: bulletRemoveIndex!)
                        bullet.removeFromParent()
                    }
                    enemy.tankHealth -= bullet.power
                    if enemy.tankHealth <= 0{
                        gameScene.enemyTanks.remove(at: tankRemoveIndex!)
                        
                        let boom = BOOM(location: enemy.position)
                        gameScene.addChild(boom)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                            boom.removeFromParent()
                        }
                        enemy.removeFromParent()
                    }
                }
                break
                
            default:
                break
            }
        }
    }
}
