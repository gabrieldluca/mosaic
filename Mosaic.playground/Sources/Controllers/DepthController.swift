import AVFoundation
import UIKit
import SceneKit

public class DepthController: UIViewController, LevelDelegate {
    
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
    private var progressViews:[CircularProgressView] = []
    private var didFitOnePiece:Bool = false
    private var fittedPiece:MovableView? = nil
    private var isColorizeEnabled:Bool = false
    
    // MARK: - Image Assets
    
    internal let images:[UIImage?] = [
        UIImage(named: "Images/Pieces/Depth/piece-0.png"),
        UIImage(named: "Images/Pieces/Depth/piece-1.png")
    ]
    internal let coloredImages:[UIImage?] = [
        UIImage(named: "Images/Pieces/Depth/piece-0-colored.png"),
        UIImage(named: "Images/Pieces/Depth/piece-1-colored.png")
    ]
    internal let frames:[CGRect] = [
        CGRect(x: 425, y: 225, width: 88.86, height: 100),
        CGRect(x: 50, y: 225, width: 88.86, height: 100)
    ]
    
    // MARK: - Sound Effects
    
    internal var rotatePlayer:AVAudioPlayer = AVAudioPlayer()
    internal var scalePlayer:AVAudioPlayer = AVAudioPlayer()
    internal var switchPlayer:AVAudioPlayer = AVAudioPlayer()
    internal var viewPlayer:AVAudioPlayer = AVAudioPlayer()
    
    // MARK: - ViewController Lifecycle methods
    
    override public func viewDidLoad() {
        sceneView.scene = self.scene
        self.view.addSubview(self.sceneView)
        
        setupScene(self.scene, withView: self.sceneView)
        self.levelSetup()
        self.addInterfaceButtons()
        
        do {
            /*
             "Light Switch" by GOSFX; "Whip 01" by erkanozans; "Dramatic Camera Zoom" by sanaku; "whoosh.wav" by LloydEvans09.
             
             Source(s): https://freesound.org/people/GOSFX/sounds/324334/ (CC BY 3.0), https://freesound.org/people/erkanozan/sounds/51755/ (CC0 1.0), https://freesound.org/people/sanaku/sounds/371882/ (CC0 1.0) & https://freesound.org/people/LloydEvans09/sounds/332003/ (CC0 1.0)
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
        
        super.viewDidLoad()
    }
    
    // MARK: - Level Delegate methods
    
    internal func levelSetup() {
        addHeader(toView: self.view)
        self.headerDescription = addDescription(toView: self.view, withText: "The quality of being profound or deep.")
        addLevelNumber(toView: self.view, withText: "2")
        
        // MARK: Adding objective shape
        self.objective = UIImageView(image: UIImage(named:"Images/Pieces/Depth/objective.png"))
        self.objective.frame = CGRect(x: 235, y: 225, width: 88.86, height: 100)
        self.view.addSubview(self.objective)
        
        // MARK: Adding pieces
        for imageInfo in zip(self.images, self.frames) {
            let piece = MovableView(image: imageInfo.0!)
            piece.frame = imageInfo.1
            piece.center.y = objective.center.y
            piece.currentSize = 0
            
            // MARK: Configuring objective
            if imageInfo.0 == self.images[0] {
                piece.objectiveVertex = CGPoint(x: self.objective.frame.maxX,
                                                y: self.objective.frame.minY)
                piece.objectiveCenter = CGPoint(x: self.objective.center.x,
                                                y: self.objective.center.y)
                piece.objectiveAngle = 3
                piece.currentAngle = 2
                piece.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1.5)
            } else {
                piece.objectiveVertex = CGPoint(x: self.objective.frame.minX,
                                                y: self.objective.frame.maxY)
                piece.objectiveCenter = CGPoint(x: self.objective.center.x,
                                                y: self.objective.center.y)
                piece.objectiveAngle = 3
                piece.currentAngle = 0
                piece.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            }
            
            piece.levelDelegate = self
            self.levelPieces.append(piece)
            self.view.addSubview(piece)
        }
    }
    
    internal func levelTeardown() {
        // MARK: Hiding interface buttons and adding pulse
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
        
        // MARK: Adding quote
        UIView.animate(withDuration: 1.0, animations: {
            self.headerDescription.alpha = 0
        }, completion: { (success: Bool) in
            self.headerDescription.text = "Colors must fit together as pieces in a puzzle or cogs in a wheel"
            self.headerDescription.center.y -= 20
            self.headerDescription.font = UIFont(name: "HelveticaNeue-Italic", size: 16)
            
            let attribution = createReference(withAuthor: "— Hans Hofmann —", relativeTo: self.headerDescription)
            self.view.addSubview(attribution)
            
            // MARK: Adding next button
            let nextButton = addToolButton(withImageNamed: "", andInsets: UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12), toX: 250)
            nextButton.setImage(UIImage(named: "Images/Icons/next.png"), for: .normal)
            nextButton.addTarget(self, action: #selector(self.didPressNextLevel(_:)), for: .touchUpInside)
            nextButton.alpha = 0
            self.view.addSubview(nextButton)
            
            // MARK: Animating views
            UIView.animate(withDuration: 0.5, animations: {
                // MARK: Showing quote
                self.headerDescription.alpha = 1
            }, completion: { (success: Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    UIView.animate(withDuration: 0.5, animations: {
                        // MARK: Showing attribution
                        attribution.alpha = 1
                    }, completion: { (success: Bool) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            UIView.animate(withDuration: 0.5, animations: {
                                // MARK: Showing next button
                                nextButton.alpha = 1
                            })
                        })
                    })
                })
            })
        })
    }
    
    internal func addInterfaceButtons() {
        // MARK: Adding view button with Long Press
        let viewButton = addToolButton(withImageNamed: "Images/Icons/view.png", andInsets: UIEdgeInsets(top: 10, left: 11.21, bottom: 10, right: 11.21), toX: 160.0)
        self.interfaceButtons.append(viewButton)
        let longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.addTarget(self, action: #selector(self.didPressView(_:)))
        longPressRecognizer.minimumPressDuration = 0.1
        viewButton.addGestureRecognizer(longPressRecognizer)
        self.view.addSubview(viewButton)
        
        // MARK: Adding other buttons with Tap
        let colorizeButton = addToolButton(withImageNamed: "Images/Icons/colorize.png", andInsets: UIEdgeInsets(top: 10, left: 11.21, bottom: 10, right: 11.21), toX: 220.0)
        colorizeButton.addTarget(self, action: #selector(self.didPressColorize(_:)), for: .touchUpInside)
        self.interfaceButtons.append(colorizeButton)
        self.view.addSubview(colorizeButton)
        
        let rotateButton = addToolButton(withImageNamed: "Images/Icons/rotate.png", andInsets: UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12), toX: 280.0)
        rotateButton.addTarget(self, action: #selector(self.didPressRotate(_:)), for: .touchUpInside)
        self.interfaceButtons.append(rotateButton)
        self.view.addSubview(rotateButton)
        
        let scaleButton = addToolButton(withImageNamed: "Images/Icons/scale.png", andInsets: UIEdgeInsets(top: 14, left: 11, bottom: 14, right: 11), toX: 340.0)
        scaleButton.addTarget(self, action: #selector(self.didPressScale(_:)), for: .touchUpInside)
        self.interfaceButtons.append(scaleButton)
        self.view.addSubview(scaleButton)
    }
    
    internal func didFit(piece: MovableView) {
        for levelPiece in self.levelPieces {
            // MARK: Determine the objective size for the remaining piece
            if piece !== levelPiece {
                if piece.currentSize == 0 {
                    levelPiece.objectiveSize = 1
                    levelPiece.objectiveAngle = 1
                } else {
                    levelPiece.objectiveSize = 0
                    levelPiece.objectiveAngle = 3
                }
                
                // MARK: Prevents overlapping pieces
                if self.didFitOnePiece == false && levelPiece == self.levelPieces[0] {
                    self.view.bringSubviewToFront(levelPiece)
                }
            }
        }
        
        if self.didFitOnePiece == false && piece.currentSize == 1 {
            self.view.bringSubviewToFront(piece)
        }
        
        self.didFitOnePiece = true
        self.fittedPiece = piece
        self.updateProgress(withValue: 0.25)
    }
    
    // MARK: Animation methods
    
    private func addPulse(toLayer: CALayer) {
        toLayer.superlayer?.insertSublayer(self.pulsator, below: toLayer)
        self.pulsator.position = toLayer.position
        self.pulsator.numPulse = 3
        self.pulsator.backgroundColor = UIColor(red:0.64, green:0.62, blue:0.88, alpha:0.5).cgColor
        self.pulsator.start()
    }
    
    // MARK: - Gesture recognizers methods
    
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
    
    // MARK: - Button interaction methods
    
    @objc private func didPressColorize(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        
        // MARK: Get images for the respective size
        let imagesToColor:[UIImage?]
        if sender.tag == 0 {
            imagesToColor = self.coloredImages
            sender.tag = 1
            self.isColorizeEnabled = true
        } else {
            imagesToColor = self.images
            sender.tag = 0
            self.isColorizeEnabled = false
        }
        
        // MARK: Updates progress accordingly
        if sender.tag == 1 {
            self.updateProgress(withValue: 0.5)
        } else {
            self.removeProgress(ofValue: 0.5)
        }
        
        // MARK: Change image for each piece
        self.switchPlayer.play()
        for piece in self.levelPieces {
            UIView.animate(withDuration: 0.5, animations: {
                piece.alpha = 0
            })
            piece.image = imagesToColor[piece.currentSize]
            UIView.animate(withDuration: 0.5, animations: {
                piece.alpha = 1
            }, completion: { (success: Bool) in
                sender.isUserInteractionEnabled = true
            })
        }
    }
    
    @objc private func didPressRotate(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        self.rotatePlayer.play()
        
        for piece in self.levelPieces {
            // MARK: Determine next angle
            let nextAngle:Int
            if piece.currentAngle == 3 {
                nextAngle = 0
            } else {
                nextAngle = piece.currentAngle + 1
            }
            
            // MARK: Rotate pieces with the respective angle
            UIView.animate(withDuration: 0.25, animations: {
                if piece.isUserInteractionEnabled {
                    piece.transform = CGAffineTransform(rotationAngle: CGFloat(angleForNumber[nextAngle]!))
                }
            }, completion: { (success: Bool) in
                sender.isUserInteractionEnabled = true
                piece.currentAngle = nextAngle
            })
        }
    }
    
    @objc private func didPressScale(_ sender: UIButton) {
        sender.isEnabled = false
        self.scalePlayer.play()
        
        for piece in self.levelPieces {
            // MARK: Determine next size
            let nextSize:Int
            if piece.currentSize == 1 {
                nextSize = 0
            } else {
                nextSize = 1
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                if piece.isUserInteractionEnabled {
                    // MARK: Scale pieces according to the next size
                    if piece.currentSize == 0 {
                        piece.objectiveCenter.y += 3.0
                        piece.frame = CGRect(x: piece.frame.minX, y: piece.frame.minY, width: piece.frame.width/2.127, height: piece.frame.height/2.12855)
                    } else {
                        piece.objectiveCenter.y -= 3.0
                        piece.frame = CGRect(x: piece.frame.minX, y: piece.frame.minY, width: piece.frame.width*2.127, height: piece.frame.height*2.12855)
                    }
                    
                    // MARK: Colorize images if needed
                    if self.isColorizeEnabled {
                        UIView.animate(withDuration: 0.5, animations: {
                            piece.alpha = 0
                        })
                        piece.image = self.coloredImages[nextSize]
                        UIView.animate(withDuration: 0.5, animations: {
                            piece.alpha = 1
                        })
                    }
                }
            }, completion: { (success: Bool) in
                // MARK: Update the current size
                if self.didFitOnePiece == true {
                    if let fitted = self.fittedPiece {
                        if piece != fitted {
                            piece.currentSize = nextSize
                        }
                    }
                } else {
                    piece.currentSize = nextSize
                    
                    // MARK: Change objective angle accordingly
                    if piece.objectiveAngle == 3 {
                        piece.objectiveAngle = 1
                    } else {
                        piece.objectiveAngle = 3
                    }
                }
            })
            
            // MARK: Re-enabling the button
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                sender.isEnabled = true
            })
        }
    }

    @objc private func didPressNextLevel(_ sender: UIButton) {
        let connection = PerspectiveController()
        connection.preferredContentSize = CGSize(width:550, height:450)
        self.present(connection, animated: true)
    }
    
    // MARK: - Progress update methods
    
    private func removeProgress(ofValue: Double) {
        // MARK: Removing previous progress
        for (index, view) in self.progressViews.enumerated() {
            UIView.animate(withDuration: 0.25, animations: {
                view.alpha = 0
            }, completion: { (sucess: Bool) in
                view.removeFromSuperview()
                self.progressViews.remove(at: index)
            })
        }
        
        // MARK: Adding brand-new progress
        let newProgress = self.progressPercentage - ofValue
        self.progressPercentage = 0.0
        self.updateProgress(withValue: newProgress)
    }
    
    private func updateProgress(withValue: Double) {
        self.progressPercentage += withValue
        let degrees = 360.0 * self.progressPercentage
        let radians = degrees * Double.pi / 180.0
        
        // MARK: Adding circular progress
        let progressView = CircularProgressView()
        progressView.endAngle = CGFloat(radians)
        progressView.frame = CGRect(x: 277.5, y: 147.5, width: 100.0, height: 100.0)
        progressView.alpha = 0
        self.progressViews.append(progressView)
        self.view.addSubview(progressView)
        
        UIView.animate(withDuration: 0.25, animations: {
            progressView.alpha = 1
        })
        
        if self.progressPercentage == 1.0 {
            self.levelTeardown()
        }
    }
}
