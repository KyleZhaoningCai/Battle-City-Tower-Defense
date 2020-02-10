import SpriteKit
import UIKit

class GameManager
{
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
    public static var baseHp = 1000
}
