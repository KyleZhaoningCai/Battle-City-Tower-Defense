/*
 File Name: DefTankAtkManager.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import GameplayKit
import AVFoundation

// This class manage bullet collision with enemy tanks
class DefTankAtkManager
{
    public static var gameViewController: GameViewController?
    
    // Same as CollisionManager.swift
    public static func squaredDistance(point1: CGPoint, point2: CGPoint) -> CGFloat
    {
        let Xs: CGFloat = point2.x - point1.x
        let Ys: CGFloat = point2.y - point1.y
        
        return Xs * Xs + Ys * Ys
    }
    
    // This function checks if bullet is colliding with any of the enemy types
    public static func squaredRadiusCheck(scene: SKScene, object1: GameObject, object2: GameObject) -> Void
    {
        let P1 = object1.position
        let P2 = object2.position
        let P1HalfHeight = object1.height! * 0.5
        let P2HalfHeight = object2.height! * 0.5
        let halfHeights = P1HalfHeight + P2HalfHeight
        
        if(squaredDistance(point1: P1, point2: P2) < (halfHeights * halfHeights + 500))
        {
            switch object2.name {
            case "silverTank2",
                 "silverTankFast1",
                 "silverTankHeavy1",
                 "greenTank2",
                 "greenTankFast1",
                 "greenTankHeave1",
                 "redTank2",
                 "redTankHeavy1":
                    let enemy: Enemy = object2 as! Enemy
                    let bullet: DefBullet = object1 as! DefBullet
                    let gameScene: GameScene = scene as! GameScene
                    // Play hit sound and effect
                    let hitSound = SKAction.playSoundFileNamed("wallHit", waitForCompletion: false)
                    gameScene.run(hitSound)
                    var bulletRemoveIndex: Int?
                    var tankRemoveIndex: Int?
                    var removeBullet = false
                    // Remove bullet and its reference
                    for index in 0..<gameScene.deftankBullets.count{
                        if gameScene.deftankBullets[index] == bullet{
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
                        gameScene.deftankBullets.remove(at: bulletRemoveIndex!)
                        bullet.removeFromParent()
                    }
                    // If enemy tank HP is less than 0
                    enemy.tankHealth -= bullet.power
                    if enemy.tankHealth <= 0{
                        // Award the player with coins
                        switch(object2.name){
                            case "silverTank2":
                                GameManager.playerCoin += 50
                                break
                            case "silverTankFast1":
                                GameManager.playerCoin += 50
                                break
                            case "silverTankHeavy1":
                                GameManager.playerCoin += 100
                                break
                            case "greenTank2":
                                GameManager.playerCoin += 150
                                break
                            case "greenTankFast1":
                                GameManager.playerCoin += 150
                                break
                            case "greenTankHeave1":
                                GameManager.playerCoin += 200
                                break
                            case "redTank2":
                                GameManager.playerCoin += 250
                                break
                            case "redTankHeavy1":
                                GameManager.playerCoin += 5000
                                // If game is not over, player wins after destroying boss
                                if GameManager.gameState != "gameOver"{
                                    GameManager.gameState = "gameVictory"
                                }
                                break
                            default:
                                break
                        }
                        gameScene.enemyTanks.remove(at: tankRemoveIndex!)
                        // Play explosion sound and dffect
                        let boom = BOOM(location: enemy.position)
                        gameScene.addChild(boom)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                            boom.removeFromParent()
                        }
                        let destroyWallSound = SKAction.playSoundFileNamed("destroy", waitForCompletion: false)
                        scene.run(destroyWallSound)
                        enemy.removeFromParent()
                    }
                
                break
            default:
                break
            }
        }
    }
}
