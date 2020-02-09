import SpriteKit

class Enemy: GameObject
{
    // constructor
    init(imageString: String)
    {
        super.init(imageString: imageString, initialScale: 2.0)
        Start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func Start()
    {
        self.zPosition = 2
    }
    
    override func Update()
    {
        
    }
}
