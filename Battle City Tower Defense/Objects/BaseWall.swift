import SpriteKit
import GameplayKit

class BaseWall: GameObject
{
    
    var objectPosition: CGPoint?
    
    //constructor
    init(positionX: CGFloat, positionY: CGFloat)
    {
        super.init(imageString: "brickWall", initialScale: 3.1)
        self.objectPosition = CGPoint(x: positionX, y: positionY)
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
}
