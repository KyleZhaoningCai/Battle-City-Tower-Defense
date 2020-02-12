//
//  DefManager.swift
//  Battle City Tower Defense
//
//  Created by Jason on 2020-02-11.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import SpriteKit
import UIKit

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

