import AVFoundation
import UIKit
import SceneKit

protocol LevelDelegate: AnyObject {

    // MARK: - Scene Properties

    var headerDescription:UILabel { get set }
    var interfaceButtons:[UIButton] { get set }
    var progressPercentage:Double { get set }
    var pulsator:Pulsator { get }
    var scene:SCNScene { get }
    var sceneView:SCNView { get }

    // MARK: - Level-specific properties

    var levelPieces:[MovableView] { get set }
    var objective:UIImageView { get set }

    // MARK: - Image Assets
    
    var coloredImages:[UIImage?] { get }
    var frames:[CGRect] { get }
    var images:[UIImage?] { get }
    
    // MARK: - SFX Players

    var rotatePlayer:AVAudioPlayer { get set }
    var scalePlayer:AVAudioPlayer { get set }
    var switchPlayer:AVAudioPlayer { get set }
    var viewPlayer:AVAudioPlayer { get set }
    
    // MARK: - Methods

    func addInterfaceButtons()
    func levelSetup()
    func levelTeardown()
    func didFit(piece: MovableView)

}
