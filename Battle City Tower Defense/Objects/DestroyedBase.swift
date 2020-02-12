import SpriteKit
import GameplayKit

class DestroyedBase: GameObject
{
    
    //constructor
    init()
    {
        super.init(imageString: "destroyedBase", initialScale: 4)
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
        self.position = GameManager.basePosition
    }
    
    override func Update()
    {
        
    }
}
