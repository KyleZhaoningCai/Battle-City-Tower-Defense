import SpriteKit
import GameplayKit

class Hit: GameObject
{
    var location: CGPoint?
    //constructor
    init(spawnLocation: CGPoint)
    {
        super.init(imageString: "hit", initialScale: 2)
        location = spawnLocation
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
        self.position = location!
        self.zPosition = 6
        self.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 0.2),
                SKAction.removeFromParent()
                ])
        )
    }
    
    override func Update()
    {
        
    }
}
