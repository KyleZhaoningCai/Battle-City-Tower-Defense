/*
 File Name: DefManager.swift
 Author: Zhaoning Cai, Supreet Kaur, Jiansheng Sun
 Student ID: 300817368, 301093932, 300997240
 Date: Feb 16, 2020
 App Description: Battle City Tower Defense
 Version Information: v1.0
 */

import SpriteKit
import UIKit

// This class stores global properties and variables for defending tanks only
class DefManager
{
    public static var hastankcheck: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    public static var tankLocations: [CGPoint] = [
        CGPoint(x: 255, y: (screenHeight!) / 2 - 700),
        CGPoint(x: 255, y: (screenHeight!) / 2 - 600),
        CGPoint(x: 255, y: (screenHeight!) / 2 - 500),
        CGPoint(x: 255, y: (screenHeight!) / 2 - 400),
        CGPoint(x: 255, y: (screenHeight!) / 2 - 300),
        CGPoint(x: 255, y: (screenHeight!) / 2 - 200),
        CGPoint(x: 155, y: (screenHeight!) / 2 - 200),
        CGPoint(x: 155, y: (screenHeight!) / 2 - 300),
        CGPoint(x: 155, y: (screenHeight!) / 2 - 400),
        CGPoint(x: 55, y: (screenHeight!) / 2 - 400),
        CGPoint(x: 255, y: (screenHeight!) / 2 - 800),
        CGPoint(x: 255, y: (screenHeight!) / 2 - 900),
        CGPoint(x: 255, y: (screenHeight!) / 2 - 1000),
        CGPoint(x: 155, y: (screenHeight!) / 2 - 1000),
        CGPoint(x: 55, y: (screenHeight!) / 2 - 1000),
        CGPoint(x: -255, y: (screenHeight!) / 2 - 1000),
        CGPoint(x: -255, y: (screenHeight!) / 2 - 200),
        CGPoint(x: -255, y: (screenHeight!) / 2 - 900),
        CGPoint(x: -255, y: (screenHeight!) / 2 - 800),
        CGPoint(x: -255, y: (screenHeight!) / 2 - 700),
        CGPoint(x: -255, y: (screenHeight!) / 2 - 600),
        CGPoint(x: -255, y: (screenHeight!) / 2 - 500),
        CGPoint(x: -255, y: (screenHeight!) / 2 - 400),
        CGPoint(x: -155, y: (screenHeight!) / 2 - 700),
        CGPoint(x: -55, y: (screenHeight!) / 2 - 700),
        CGPoint(x: -255, y: (screenHeight!) / 2 - 300)
    ]
    public static let basePosition: CGPoint = CGPoint(x: 75, y: -625)
    public static var baseHp = 1000
}

