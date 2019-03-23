import AVFoundation
import UIKit
import SceneKit
// Se a pessoa apertar no final tem que voltar pro nível onde ela fez a peça

public class MergeController: UIViewController, LevelDelegate {
    
    // MARK: - Scene properties
    
    internal let scene:SCNScene = SCNScene()
    internal let sceneView:SCNView = SCNView()
    internal var progressPercentage:Double = 0
    internal let pulsator:Pulsator = Pulsator()
    internal var interfaceButtons:[UIButton] = []
    internal var headerDescription:UILabel = UILabel()
    
    // MARK: - Level-specific properties
    
    internal var objective:UIImageView = UIImageView()
    internal var levelPieces:[MovableView] = []
    
    // MARK: - Image Assets
    
    internal let images:[UIImage?] = [
        UIImage(named: "Images/Pieces/Merge/piece-0.png"),
        UIImage(named: "Images/Pieces/Merge/piece-1.png")
    ]
    internal let coloredImages:[UIImage?] = [
        UIImage(named: "Images/Pieces/Merge/piece-0-colored.png"),
        UIImage(named: "Images/Pieces/Merge/piece-1-colored.png")
    ]
    internal let frames:[CGRect] = [
        CGRect(x: 50, y: 230.625, width: 68.29, height: 88.75),
        CGRect(x: 425, y: 230.625, width: 68.25, height: 88.66)
    ]
    
    // MARK: - SFX Players
    
    internal var rotatePlayer:AVAudioPlayer = AVAudioPlayer()
    internal var scalePlayer:AVAudioPlayer = AVAudioPlayer()
    internal var switchPlayer:AVAudioPlayer = AVAudioPlayer()
    internal var viewPlayer:AVAudioPlayer = AVAudioPlayer()
    
    // MARK: - ViewController Lifecycle methods
    
    override public func viewDidLoad() {
        sceneView.scene = self.scene
        self.view.addSubview(self.sceneView)
        
        setupScene(self.scene, withView: self.sceneView)
        
        do {
            /*
             "Light Switch" by GOSFX; "Whip 01" by erkanozans; "Dramatic Camera Zoom" by sanaku; "whoosh.wav" by LloydEvans09.
             
             Source(s): https://freesound.org/people/GOSFX/sounds/324334/ (CC BY 3.0), https://freesound.org/people/erkanozan/sounds/51755/ (CC0 1.0) & https://freesound.org/people/sanaku/sounds/371882/ (CC0 1.0)
             */
            let rotateAudioPath = Bundle.main.path(forResource: "Sound/whip", ofType: "wav")
            let scaleAudioPath = Bundle.main.path(forResource: "Sound/scale", ofType: "wav")
            let switchAudioPath = Bundle.main.path(forResource: "Sound/light-switch", ofType: "mp3")
            let viewAudioPath = Bundle.main.path(forResource: "Sound/view", ofType: "mp3")
            
            
            try self.rotatePlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: rotateAudioPath!) as URL)
            try self.scalePlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: scaleAudioPath!) as URL)
            try self.switchPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: switchAudioPath!) as URL)
            try self.viewPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: viewAudioPath!) as URL)
        } catch {
            print("Couldn't find background music file.")
        }
        
        self.rotatePlayer.volume = 0.3
        self.scalePlayer.volume = 0.3
        self.switchPlayer.volume = 1.5
        
        self.rotatePlayer.prepareToPlay()
        self.scalePlayer.prepareToPlay()
        self.switchPlayer.prepareToPlay()
        self.viewPlayer.prepareToPlay()
    
        self.levelSetup()
        self.addInterfaceButtons()
        
        super.viewDidLoad()
    }
    
    // MARK: - Level Delegate methods
    
    internal func levelSetup() {
        // MARK: Adding objective description
        addHeader(toView: self.view)
        self.headerDescription = addDescription(toView: self.view, withText: "Combine or cause to form a single entity.")
        addLevelNumber(toView: self.view, withText: "1")
        
        // MARK: Adding objective shape
        self.objective = UIImageView(image: UIImage(named:"Images/Pieces/Merge/objective.png"))
        self.objective.frame = CGRect(x: 225, y: 225, width: 91, height: 100)
        self.view.addSubview(self.objective)
        
        // MARK: Adding pieces
        for imageInfo in zip(self.images, self.frames) {
            let piece = MovableView(image: imageInfo.0!)
            piece.frame = imageInfo.1
            piece.center.y = objective.center.y
            
            piece.objectiveSize = 0
            piece.currentSize = 0
            
            // MARK: Configuring objective
            if imageInfo.0 == self.images[0] {
                piece.objectiveVertex = CGPoint(x: self.objective.frame.maxX,
                                                y: self.objective.frame.minY)
                piece.objectiveCenter = CGPoint(x: 281.73, y: 269.44)
                piece.objectiveAngle = 3
                piece.currentAngle = 1
                piece.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            } else {
                piece.objectiveVertex = CGPoint(x: self.objective.frame.minX,
                                                y: self.objective.frame.maxY)
                piece.objectiveCenter = CGPoint(x: 259.27, y: 280.57)
                piece.objectiveAngle = 3
                piece.currentAngle = 3
                piece.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }
            
            piece.levelDelegate = self
            self.levelPieces.append(piece)
            self.view.addSubview(piece)
        }
    }
    
    internal func levelTeardown() {
        for button in self.interfaceButtons {
            UIView.animate(withDuration: 1.0, animations: {
                button.alpha = 0
            }, completion: { (success: Bool) in
                button.removeFromSuperview()
            })
        }
        UIView.animate(withDuration: 1.0, animations: {
            self.pulsator.radius = 75
            self.addPulse(toLayer: self.objective.layer)
        })
        
        UIView.animate(withDuration: 1.0, animations: {
            self.headerDescription.alpha = 0
        }, completion: { (success: Bool) in
            self.headerDescription.text = "The art of simplicity is a puzzle of complexity"
            self.headerDescription.center.y -= 20
            self.headerDescription.font = UIFont(name: "HelveticaNeue-Italic", size: 16)

            let attribution = createReference(withAuthor: "— Douglas Horton —", relativeTo: self.headerDescription)
            self.view.addSubview(attribution)

            // MARK: Adding next button
            let nextButton = addToolButton(withImageNamed: "", andInsets: UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12), toX: 250)
            nextButton.setImage(UIImage(named: "Images/Icons/next.png"), for: .normal)
            nextButton.addTarget(self, action: #selector(self.didPressNextLevel(_:)), for: .touchUpInside)
            nextButton.alpha = 0
            self.view.addSubview(nextButton)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.headerDescription.alpha = 1
            }, completion: { (success: Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    UIView.animate(withDuration: 0.5, animations: {
                        attribution.alpha = 1
                    }, completion: { (success: Bool) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            UIView.animate(withDuration: 0.5, animations: {
                                nextButton.alpha = 1
                            })
                        })
                    })
                })
            })
        })
    }
    
    internal func addInterfaceButtons() {
        let viewButton = addToolButton(withImageNamed: "Images/Icons/view.png", andInsets: UIEdgeInsets(top: 10, left: 11.21, bottom: 10, right: 11.21), toX: 160.0)
        self.interfaceButtons.append(viewButton)
        let longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.addTarget(self, action: #selector(self.didPressView(_:)))
        longPressRecognizer.minimumPressDuration = 0.1
        viewButton.addGestureRecognizer(longPressRecognizer)
        self.view.addSubview(viewButton)
        
        let colorizeButton = addToolButton(withImageNamed: "Images/Icons/colorize.png", andInsets: UIEdgeInsets(top: 12, left: 13, bottom: 12, right: 13), toX: 220.0)
        colorizeButton.addTarget(self, action: #selector(self.didPressColorize(_:)), for: .touchUpInside)
        self.interfaceButtons.append(colorizeButton)
        self.view.addSubview(colorizeButton)
        
        let rotateButton = addToolButton(withImageNamed: "Images/Icons/rotate.png", andInsets: UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10), toX: 280.0)
        rotateButton.addTarget(self, action: #selector(self.didPressRotate(_:)), for: .touchUpInside)
        self.interfaceButtons.append(rotateButton)
        self.view.addSubview(rotateButton)
        
        let scaleButton = addToolButton(withImageNamed: "Images/Icons/scale.png", andInsets: UIEdgeInsets(top: 14, left: 9, bottom: 14, right: 9), toX: 340.0)
        scaleButton.addTarget(self, action: #selector(self.didPressScale(_:)), for: .touchUpInside)
        self.interfaceButtons.append(scaleButton)
        self.view.addSubview(scaleButton)
    }
    
    internal func didFit(piece: MovableView) {
        self.updateProgress(withValue: (100.0/Double(self.images.count))/100.0)
    }
    
    private func addPulse(toLayer: CALayer) {
        toLayer.superlayer?.insertSublayer(self.pulsator, below: toLayer)
        self.pulsator.position = toLayer.position
        self.pulsator.numPulse = 3
        self.pulsator.backgroundColor = UIColor(red:0.64, green:0.62, blue:0.88, alpha:0.5).cgColor
        self.pulsator.start()
    }
    
    // MARK: - Button interaction methods
    
    @objc private func didPressView(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            self.viewPlayer.play()
            self.objective.alpha = 0
            self.view.bringSubviewToFront(self.objective)
            UIView.animate(withDuration: 0.25, animations: {
                self.objective.alpha = 1
            })
        }
        if gesture.state == UIGestureRecognizer.State.ended {
            UIView.animate(withDuration: 0.25, animations: {
                self.objective.alpha = 0
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self.view.sendSubviewToBack(self.objective)
                self.view.sendSubviewToBack(self.sceneView)
                self.objective.alpha = 1
            })
        }
    }
    
    @objc private func didPressColorize(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        let imagesToColor:[UIImage?]
        if sender.tag == 0 {
            imagesToColor = self.coloredImages
            sender.tag = 1
            sender.setImage(UIImage(named: "Images/Icons/colorize-remove.png"), for: .normal)
        } else {
            imagesToColor = self.images
            sender.tag = 0
            sender.setImage(UIImage(named: "Images/Icons/colorize.png"), for: .normal)
        }
        
        self.switchPlayer.play()
        for piece in zip(self.levelPieces, imagesToColor) {
            UIView.animate(withDuration: 0.5, animations: {
                piece.0.alpha = 0
            })
            piece.0.image = piece.1
            UIView.animate(withDuration: 0.5, animations: {
                piece.0.alpha = 1
            }, completion: { (sucess: Bool) in
                sender.isUserInteractionEnabled = true
            })
        }
    }
    
    @objc private func didPressRotate(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        self.rotatePlayer.play()
        for piece in self.levelPieces {
            
            let nextAngle:Int
            if piece.currentAngle == 3 {
                nextAngle = 0
            } else {
                nextAngle = piece.currentAngle + 1
                
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                if piece.isUserInteractionEnabled {
                    piece.transform = CGAffineTransform(rotationAngle: CGFloat(angleForNumber[nextAngle]!))
                }
            }, completion: { (sucess: Bool) in
                sender.isUserInteractionEnabled = true
                piece.currentAngle = nextAngle
            })
        }
    }
    
    @objc private func didPressScale(_ sender: UIButton) {
        sender.isEnabled = false
        self.scalePlayer.play()
        
        for piece in self.levelPieces {
            let nextSize:Int
            if piece.currentSize == 1 {
                nextSize = 0
            } else {
                nextSize = 1
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                if piece.isUserInteractionEnabled {
                    if piece.currentSize == 0 {
                        piece.frame = CGRect(x: piece.frame.minX, y: piece.frame.minY, width: piece.frame.width/2.127, height: piece.frame.height/2.12855)
                    } else {
                        piece.frame = CGRect(x: piece.frame.minX, y: piece.frame.minY, width: piece.frame.width*2.127, height: piece.frame.height*2.12855)
                    }
                }
            }, completion: { (success: Bool) in
                piece.currentSize = nextSize
            })
        }
        
        // MARK: Re-enabling the button
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            sender.isEnabled = true
        })
    }
    
    @objc private func didPressNextLevel(_ sender: UIButton) {
        let connection = DepthController()
        connection.preferredContentSize = CGSize(width:550, height:450)
        self.present(connection, animated: true)
    }
    
    // MARK: - Progress update methods
    
    private func updateProgress(withValue: Double) {
        // MARK: Calculating radians
        self.progressPercentage += withValue
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
