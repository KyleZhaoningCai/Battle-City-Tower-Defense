
import SpriteKit
import GameplayKit

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
        
        if(squaredDistance(point1: P1, point2: P2) < halfHeights * halfHeights)
        {
            switch object2.name {
            case "largeBrickWall":
                let brickWall: BrickWall = object2 as! BrickWall
                let bullet: Bullet = object1 as! Bullet
                let gameScene: GameScene = object2.parent as! GameScene
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
                    GameManager.hasWallCheck[wallToRemove!.index!] = false
                    for enemy in gameScene.enemyTanks{
                        enemy.stopOthers = false
                    }
                    brickWall.removeFromParent()
                }
                break
            case "brickWall":
                let bullet: Bullet = object1 as! Bullet
                let gameScene: GameScene = object2.parent as! GameScene
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
                }
                break
            default:
                break
            }
        }
    }
}
