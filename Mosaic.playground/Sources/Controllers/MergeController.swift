import UIKit
import SceneKit

public class MergeController: UIViewController, LevelDelegate {
    
    // MARK: - Variables
    
    private let scene:SCNScene = SCNScene()
    private let sceneView:SCNView = SCNView()
    private var progressPercentage:Double = 0
    
    // MARK: - Asset variables
    
    private let images = [
        UIImage(named: "Images/Pieces/Merge/piece-0.png"),
        UIImage(named: "Images/Pieces/Merge/piece-1.png")
    ]
    private let frames = [
        CGRect(x: 50, y: 295, width: 68.29, height: 88.75),
        CGRect(x: 425, y: 295, width: 68.25, height: 88.66)
    ]
    
    // MARK: - ViewController Lifecycle methods
    
    override public func viewDidLoad() {
        sceneView.scene = self.scene
        self.view.addSubview(self.sceneView)
        
        setupScene(self.scene, withView: self.sceneView)
        self.levelSetup()
    
        super.viewDidLoad()
    }
    
    // MARK: - Level Delegate methods
    
    internal func levelSetup() {
        
        // MARK: Adding objective description
        
        addHeader(toView: self.view)
        addDescription(toView: self.view, withText: "Combine or cause to form a single entity.")
        addLevelNumber(toView: self.view, withText: "1")
        
        // MARK: Adding objective shape
        let objective = UIImageView(image: UIImage(named:"Images/Pieces/Merge/objective.png"))
        objective.frame = CGRect(x: 225, y: 275, width: 91, height: 100)
        self.view.addSubview(objective)
        
        // MARK: Adding pieces
        for imageInfo in zip(self.images, self.frames) {
            let piece = MovableView(image: imageInfo.0!)
            piece.frame = imageInfo.1
            
            // MARK: Configuring objective
            if imageInfo.0 == self.images[0] {
                piece.objectiveVertex = CGPoint(x: objective.frame.maxX, y: objective.frame.minY)
                piece.objectiveCenter = CGPoint(x: 281.73, y: 319.44)
            } else {
                piece.objectiveVertex = CGPoint(x: objective.frame.minX, y: objective.frame.maxY)
                piece.objectiveCenter = CGPoint(x: 259.27, y: 330.57)
            }
            
            piece.levelDelegate = self
            self.view.addSubview(piece)
        }
    }
    
    internal func levelTeardown() {
        // MARK: Present next level
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            let connection = DeepenController()
            connection.preferredContentSize = CGSize(width:550, height:450)
            self.present(connection, animated: true)
        })
    }
    
    internal func didFit(piece: MovableView) {
        // MARK: Calculating radians
        self.progressPercentage += (100.0/Double(self.images.count))/100.0
        let degrees = 360.0 * self.progressPercentage
        let radians = degrees * Double.pi / 180.0
        
        // MARK: Adding circular progress
        let progressView = CircularProgressView()
        progressView.endAngle = CGFloat(radians)
        progressView.frame = CGRect(x: 277.5, y: 147.5, width: 100.0, height: 100.0)
        progressView.alpha = 0
        self.view.addSubview(progressView)
        
        UIView.animate(withDuration: 0.25, animations: {
            progressView.alpha = 1
        })
        
        // MARK: Check for level ending
        if self.progressPercentage == 1.0 {
            self.levelTeardown()
        }
    }
}
