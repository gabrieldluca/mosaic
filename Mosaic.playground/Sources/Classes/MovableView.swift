import UIKit
import AVFoundation

class MovableView: UIImageView {
    
    // MARK: - Variables
    
    private var isMoving:Bool = false
    private var origin:CGPoint = CGPoint.zero
    public var currentAngle:Int = 0
    public var currentSize:Int = 0
    weak var levelDelegate:LevelDelegate?
    
    override public var frame:CGRect {
        willSet {
            self.origin = CGPoint(x: newValue.midX, y: newValue.midY)
        }
    }
    
    // MARK: - Objective
    
    public var objectiveVertex:CGPoint = CGPoint.zero
    public var objectiveCenter:CGPoint = CGPoint.zero
    public var objectiveAngle:Int = 0
    public var objectiveSize:Int = -1
    
    // MARK: - Sound Effects
    
    private var correctEffect:AVAudioPlayer = AVAudioPlayer()
    private var wrongEffect:AVAudioPlayer = AVAudioPlayer()
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(image: UIImage) {
        super.init(image: image)
        self.isUserInteractionEnabled = true
        
        do {
            /*
             "ecofuture1" by soneproject; "Game Sound InCorrect Organic Violin" by Bertrof
             
             Source: https://freesound.org/people/soneproject/sounds/345272/ (CC BY 3.0) & https://freesound.org/people/Bertrof/sounds/351565/ (CC BY 3.0)
             */
            let correctAudioPath = Bundle.main.path(forResource: "Sound/right", ofType: "wav")
            let wrongAudioPath = Bundle.main.path(forResource: "Sound/wrong", ofType: "wav")
            
            try self.correctEffect = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: correctAudioPath!) as URL)
            try self.wrongEffect = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: wrongAudioPath!) as URL)
        } catch {
            print("Couldn't find background music file.")
        }
        
        self.wrongEffect.volume = 0.4
        self.correctEffect.prepareToPlay()
        self.wrongEffect.prepareToPlay()
    }
    
    // MARK: - Touch Methods
    
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
        
        if self.objectiveSize == -1 {
            self.objectiveSize = self.currentSize
        }
        
        if abs(deltaX) <= 20 && abs(deltaY) <= 20 && self.currentAngle == self.objectiveAngle && self.currentSize == self.objectiveSize {
            UIView.animate(withDuration: 0.25, animations: {
                self.center = self.objectiveCenter
            })
            self.correctEffect.play()
            self.isUserInteractionEnabled = false
            self.levelDelegate?.didFit(piece: self)
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.center = self.origin
            })
            self.wrongEffect.play()
        }
    }
}
