import UIKit
import SceneKit

public class IntroController: UIViewController {
    
    // MARK: - Variables
    
    private let scene:SCNScene = SCNScene()
    private let sceneView:SCNView = SCNView()
    private let pulsator:Pulsator = Pulsator()
    
    // MARK: - Asset variables
    
    private let images = [
        UIImage(named: "Images/Pieces/Intro/piece-0.png"),
        UIImage(named: "Images/Pieces/Intro/piece-1.png"),
        UIImage(named: "Images/Pieces/Intro/piece-2.png"),
        UIImage(named: "Images/Pieces/Intro/piece-3.png")
    ]
    private let frames = [
        CGRect(x: 50, y: 75, width: 55, height: 54),
        CGRect(x: 465, y: 75, width: 25, height: 43.76),
        CGRect(x: 75, y: 300, width: 55, height: 54),
        CGRect(x: 400, y: 350, width: 55, height: 54)
    ]
    private var introductionViews:[UIView] = []
    
    // MARK: - ViewController lifecycle methods
    
    override public func viewDidLoad() {
        
        sceneView.scene = self.scene
        self.view.addSubview(self.sceneView)
        
        // MARK: Configuring scene
        setupScene(self.scene, withView: self.sceneView)
        
        // MARK: Loading image assets
        for imageInfo in zip(self.images, self.frames) {
            let view = UIImageView(image: imageInfo.0)
            view.frame = imageInfo.1
            self.introductionViews.append(view)
        }
        self.animate(views: self.introductionViews, withDelta: 3.0)
        
        // MARK: Add acknowledgments button
        let creditsButton = UIButton(frame: CGRect(x: 275, y: 350, width: 25, height: 19.92))
        creditsButton.setBackgroundImage(UIImage(named: "Images/Pieces/Intro/piece-4.png"), for: .normal)
        self.view.addSubview(creditsButton)
        self.addPulse(toLayer: creditsButton.layer)
        self.introductionViews.append(creditsButton)
        
        self.setStartButton()
        super.viewDidLoad()
    }
    
    // MARK: - Particle Systems methods
    
    private func addEmmiterNode(forParticle: SCNParticleSystem?, inFrontOf: SCNNode) {
        let particleEmitter = SCNNode()
        if let particles = forParticle {
            particleEmitter.addParticleSystem(particles)
        }
        
        self.scene.rootNode.addChildNode(particleEmitter)
        let position = SCNVector3(x: 0, y: 0, z: 3)
        updatePositionAndOrientationOf(particleEmitter, withPosition: position, relativeTo: inFrontOf)
    }
    
    // MARK: - Animation methods
    
    private func addPulse(toLayer: CALayer) {
        toLayer.superlayer?.insertSublayer(self.pulsator, below: toLayer)
        self.pulsator.position = toLayer.position
        self.pulsator.numPulse = 3
        self.pulsator.backgroundColor = UIColor(red:0.64, green:0.62, blue:0.88, alpha:0.5).cgColor
        self.pulsator.start()
    }
    
    private func animate(views: [UIView], withDelta: Double) {
        var delta = withDelta
        for view in views {
            UIView.animate(withDuration: 7.5, delay: 0, options: [.repeat, .autoreverse], animations: {
                view.transform = view.transform.rotated(by: CGFloat(Double.pi/18.0 * delta))
            })
            delta *= 2
            self.view.addSubview(view)
        }
    }
    
    // MARK: - Others
    
    private func setStartButton() {
        let button = UIButton(frame: CGRect(x: 200, y: 175, width: 175, height: 65))
        button.layer.cornerRadius = button.frame.height/2
        button.layer.masksToBounds = true
        
        button.setBackgroundColor(color: UIColor(red:0.64, green:0.62, blue:0.88, alpha:0.5), forState: .normal)
        button.setBackgroundColor(color: UIColor(red:0.57, green:0.36, blue:0.97, alpha:1.0), forState: .selected)
        
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        
        button.addTarget(self, action: #selector(self.didPressStart), for: .touchUpInside)
        
        self.introductionViews.append(button)
        self.view.addSubview(button)
        
    }
    
    @objc private func didPressStart() {
        self.pulsator.stop()
        for view in self.introductionViews {
            UIView.animate(withDuration: 1.5, animations: {
                view.alpha = 0
            }, completion: { (sucess: Bool) in
                view.removeFromSuperview()
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75, execute: {
            let connection = MergeController()
            connection.preferredContentSize = CGSize(width:550, height:450)
            self.present(connection, animated: true)
        })
    }
}

