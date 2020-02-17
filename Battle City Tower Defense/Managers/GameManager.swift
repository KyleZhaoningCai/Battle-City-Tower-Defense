/*
 File Name: GameManager.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import UIKit

// This class stores global properties and variables
class GameManager
{
    public static var waypoints: [CGPoint] = []
    public static var isStoppingPoints: [Bool] = []
    public static var targetPoints: [CGPoint] = []
    public static var hasWallCheck: [Bool] = [false, false, false, false, false, false, false]
    public static var wallLocations: [CGPoint] = [
        CGPoint(x: 100, y: (screenHeight!) / 2 - 650),
        CGPoint(x: 100, y: (screenHeight!) / 2 - 750),
        CGPoint(x: 100, y: (screenHeight!) / 2 - 850),
        CGPoint(x: 0, y: (screenHeight!) / 2 - 850),
        CGPoint(x: -100, y: (screenHeight!) / 2 - 850),
        CGPoint(x: -100, y: (screenHeight!) / 2 - 950),
        CGPoint(x: -100, y: (screenHeight!) / 2 - 1050)
    ]
    public static let basePosition: CGPoint = CGPoint(x: 75, y: -625)
    public static var baseHp: Int = 1000
    public static var playerCoin: Int = 500
    public static var gameState: String = "onGoing"
}

