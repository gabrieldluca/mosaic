import UIKit
import SceneKit

public class MergeController: UIViewController, UIGestureRecognizerDelegate, MergeLevelDelegate {
    
    // MARK: - Variables
    
    private let scene:SCNScene = SCNScene()
    private let sceneView:SCNView = SCNView()
    private let pulsator:Pulsator = Pulsator()
    private var progress:Int = 0
    
    // MARK: - Assets variables
    
    private let images = [
        UIImage(named: "Assets/Pieces/Merge/piece-0.png"),
        UIImage(named: "Assets/Pieces/Merge/piece-1.png")
    ]
    private let frames = [
        CGRect(x: 50, y: 75, width: 68.29, height: 88.75),
        CGRect(x: 465, y: 75, width: 68.25, height: 88.66)
    ]
    
    // MARK: - Lifecycle methods
    
    override public func viewDidLoad() {
        sceneView.scene = self.scene
        self.view.addSubview(self.sceneView)
        
        setupScene(self.scene, withView: self.sceneView)
        self.configureLevel()
        
        super.viewDidLoad()
    }
    
    private func configureLevel() {
        let objective = UIImageView(image: UIImage(named:"Assets/Pieces/Merge/objective.png"))
        objective.frame = CGRect(x: 225, y: 175, width: 91, height: 100)
        self.view.addSubview(objective)
        
        for imageInfo in zip(self.images, self.frames) {
            let piece = MovableView(image: imageInfo.0!)
            piece.frame = imageInfo.1
            
            if imageInfo.0 == self.images[0] {
                piece.objectiveVertex = CGPoint(x: objective.frame.maxX, y: objective.frame.minY)
                piece.objectiveCenter = CGPoint(x: 281.73, y: 219.44)
            } else {
                piece.objectiveVertex = CGPoint(x: objective.frame.minX, y: objective.frame.maxY)
                piece.objectiveCenter = CGPoint(x: 259.27, y: 230.57)
            }
            
            piece.levelDelegate = self
            self.view.addSubview(piece)
        }
    }
    
    internal func didFit(piece: MovableView) {
        self.progress += 1
        if self.progress == 2 {
            // Level ended
        }
    }
}
