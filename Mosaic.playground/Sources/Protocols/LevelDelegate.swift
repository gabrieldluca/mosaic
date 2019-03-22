import AVFoundation
import UIKit
import SceneKit

protocol LevelDelegate: AnyObject {

    // MARK: - Properties

    var scene:SCNScene { get }
    var sceneView:SCNView { get }
    var progressPercentage:Double { get set }
    var levelPieces:[MovableView] { get set }
    
    var switchPlayer:AVAudioPlayer { get set }
    var rotatePlayer:AVAudioPlayer { get set }
    
    // MARK: - Assets
    
    var images:[UIImage?] { get }
    var coloredImages:[UIImage?] { get }
    var frames:[CGRect] { get }

    // MARK: - Methods
    
    func didFit(piece: MovableView)
    func levelSetup()
    func levelTeardown()
}
