/*
 File Name: CollisionManager.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit
import AVFoundation

// This class manages bullet collision with various GameObjects
class CollisionManager
{
    public static var gameViewController: GameViewController?
    
    // This function checks the square distance between 2 CGPoints
    public static func squaredDistance(point1: CGPoint, point2: CGPoint) -> CGFloat
    {
        let Xs: CGFloat = point2.x - point1.x
        let Ys: CGFloat = point2.y - point1.y
        
        return Xs * Xs + Ys * Ys
    }
    
    // This function checks if 2 GameObjects are colliding
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
            // If enemy bullet is colliding with a player placed wall
            case "largeBrickWall":
                // Play hit sound and effect
                let hitWallSound = SKAction.playSoundFileNamed("wallHit", waitForCompletion: false)
                scene.run(hitWallSound)
                let hit: Hit = Hit(spawnLocation: P1)
                scene.addChild(hit)
                let brickWall: BrickWall = object2 as! BrickWall
                let bullet: Bullet = object1 as! Bullet
                let gameScene: GameScene = scene as! GameScene
                brickWall.reductHp(amount: bullet.power) // Reduce the wall hp by bullet power
                var bulletRemoveIndex: Int?
                var wallRemoveIndex: Int?
                var wallToRemove: BrickWall?
                var removeBullet = false
                var removeWall = false
                // Remove the bullet and its references
                for index in 0..<gameScene.enemyBullets.count{
                    if gameScene.enemyBullets[index] == bullet{
                        removeBullet = true
                        bulletRemoveIndex = index
                    }
                }
                // If the wall hp is less than 0, remove the wall and its references
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
                    // Play explosion sound and effect
                    let boom = BOOM(location: brickWall.position)
                    gameScene.addChild(boom)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        boom.removeFromParent()
                    }
                    brickWall.removeFromParent()
                    let destroyWallSound = SKAction.playSoundFileNamed("destroy", waitForCompletion: false)
                    scene.run(destroyWallSound)
                }
                break
            // If enemy bullet is colliding with the base wall
            case "brickWall":
                // Play hit sound and effect
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
                // Remove bullet and its references
                for index in 0..<gameScene.enemyBullets.count{
                    if gameScene.enemyBullets[index] == bullet{
                        removeBullet = true
                        bulletRemoveIndex = index
                    }
                }
                // Remove all baes walls if the base wall HP is less than 0
                if (GameManager.baseHp <= 0){
                    removeBaseWall = true
                }
                if (removeBullet){
                    gameScene.enemyBullets.remove(at: bulletRemoveIndex!)
                    bullet.removeFromParent()
                }
                // Play explosion sound and effect
                if (removeBaseWall){
                    for baseWall in gameScene.baseWalls{
                        let boom = BOOM(location: baseWall.position)
                        gameScene.addChild(boom)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                            boom.removeFromParent()
                        }
                        baseWall.removeFromParent()
                    }
                    gameScene.baseWalls = []
                    let destroyWallSound = SKAction.playSoundFileNamed("destroy", waitForCompletion: false)
                    scene.run(destroyWallSound)
                }
                break
            // If enemy bullet is colliding with the base
            case "bird":
                // Play hit sound and effect
                let hitWallSound = SKAction.playSoundFileNamed("wallHit", waitForCompletion: false)
                scene.run(hitWallSound)
                let hit: Hit = Hit(spawnLocation: P1)
                scene.addChild(hit)
                let bullet: Bullet = object1 as! Bullet
                let gameScene: GameScene = scene as! GameScene
                var bulletRemoveIndex: Int?
                var removeBullet = false
                // Remove bullet and its references
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
                // Play explosion sound and effect
                let boom = BOOM(location: object2.position)
                gameScene.addChild(boom)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    boom.removeFromParent()
                }
                let destroyWallSound = SKAction.playSoundFileNamed("destroy", waitForCompletion: false)
                scene.run(destroyWallSound)
                // Replace the base sprite with destroyedBase sprite
                object2.removeFromParent()
                let destroyedBase: DestroyedBase = DestroyedBase()
                gameScene.addChild(destroyedBase)
                GameManager.gameState = "gameOver" // Set game state to game over
                break
            default:
                break
            }
        }
    }
}
