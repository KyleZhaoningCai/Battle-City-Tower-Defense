//
//  Enemy.swift
//  Battle City Tower Defense
//
//  Created by Zhaoning Cai on 2020-02-08.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import SpriteKit

struct EnemyStruct: Codable {
    var name: String
    var sprite: String
    var health: Int
    var speed: CGFloat
    var attack: Int
}

