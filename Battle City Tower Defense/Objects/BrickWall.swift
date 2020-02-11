import SpriteKit
import GameplayKit

class BrickWall: GameObject
{
    
    var objectPosition: CGPoint?
    var hp = 100
    var index: Int?
    
    //constructor
    init(positionX: CGFloat, positionY: CGFloat, checkWallIndex: Int)
    {
        super.init(imageString: "largeBrickWall", initialScale: 3.1)
        self.objectPosition = CGPoint(x: positionX, y: positionY)
        index = checkWallIndex
        Start()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Move()
    {
        
    }
    
    override func Start()
    {
        self.position = objectPosition ?? CGPoint(x: 1000, y: 1000)
    }
    
    override func Update()
    {
        
    }
    
    func reductHp(amount: Int){
        hp -= amount
    }
}
