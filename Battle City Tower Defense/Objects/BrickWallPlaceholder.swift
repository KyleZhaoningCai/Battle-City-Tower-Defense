import SpriteKit
import GameplayKit

class BrickWallPlaceholder: GameObject
{
    
    var objectPosition: CGPoint?
    
    //constructor
    init(positionX: CGFloat, positionY: CGFloat)
    {
        super.init(imageString: "placeholder", initialScale: 2.5)
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
        self.zPosition = 5
        self.position = objectPosition ?? CGPoint(x: 1000, y: 1000)
    }
    
    override func Update()
    {
        
    }
}
