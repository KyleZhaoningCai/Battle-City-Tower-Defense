import SpriteKit
import GameplayKit

class Island: GameObject
{

    //constructor
    init(positionX: CGFloat, positionY: CGFloat)
    {
        super.init(imageString: "river", initialScale: 2.0)
        Start()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle Functions
    override func CheckBounds()
    {

    }
    
    func Move()
    {
        
    }
    
    override func Reset()
    {

    }
    
    override func Start(positionX: CGFloat, positionY: CGFloat)
    {
        self.position.y = positionY;
        self.position.x = positionX;
    }
    
    override func Update()
    {

    }
}
