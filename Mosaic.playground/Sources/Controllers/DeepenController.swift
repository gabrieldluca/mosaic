import UIKit
import SceneKit

public class DeepenController: UIViewController, LevelDelegate {
    
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
        addHeader(toView: self.view)
        addDescription(toView: self.view, withText: "The quality of being profound or deep.")
        addLevelNumber(toView: self.view, withText: "2")
    }
    
    internal func levelTeardown() {
    }
    
    internal func didFit(piece: MovableView) {
    }
}
