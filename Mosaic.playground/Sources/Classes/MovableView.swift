import UIKit

class MovableView: UIImageView {
    
    // MARK: - Variables
    private var isMoving:Bool = false
    public var objectiveVertex:CGPoint = CGPoint.zero
    public var objectiveCenter:CGPoint = CGPoint.zero
    weak var levelDelegate:LevelDelegate?
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(image: UIImage) {
        super.init(image: image)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = event?.allTouches?.first
        let touchPoint = touch?.location(in: self.window)
        
        if self.frame.contains(touchPoint!){
            self.isMoving = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = event?.allTouches?.first
        let touchPoint = touch?.location(in: self.window)
        
        if self.isMoving {
            self.center = CGPoint(x: (touchPoint?.x)!, y: (touchPoint?.y)!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isMoving = false
        
        let deltaX = self.objectiveCenter.x - self.center.x
        let deltaY = self.objectiveCenter.y - self.center.y
        
        if abs(deltaX) <= 15 && abs(deltaY) <= 15 {
            UIView.animate(withDuration: 0.25, animations: {
                self.center = self.objectiveCenter
            })
            self.isUserInteractionEnabled = false
            self.levelDelegate?.didFit(piece: self)
        }
    }
}
