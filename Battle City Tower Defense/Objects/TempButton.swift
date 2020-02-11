import SpriteKit
import GameplayKit

class TempButton: GameObject
{
    
    //constructor
    init()
    {
        super.init(imageString: "grass", initialScale: 5)
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
        self.position = CGPoint(x: -225, y: 0)
    }
    
    override func Update()
    {
        
    }
}
