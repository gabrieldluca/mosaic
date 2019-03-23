import UIKit
import SceneKit

public class EndingController: UIViewController {
    
    // MARK: - Scene properties
    
    private let scene:SCNScene = SCNScene()
    private let sceneView:SCNView = SCNView()
    
    // MARK: - Image Assets
    
    internal let builtImages:[UIImage?] = [
        UIImage(named: "Images/Pieces/Merge/objective.png"),
        UIImage(named: "Images/Pieces/Depth/objective.png"),
        UIImage(named: "Images/Pieces/Perspective/objective.png")
    ]
    internal let frames:[CGRect] = [
        CGRect(x: 75, y: 200, width: 91, height: 100),
        CGRect(x: 235, y: 200, width: 88.86, height: 100),
        CGRect(x: 400, y: 200, width: 88.92, height: 100)
    ]
    
    // MARK: - ViewController Lifecycle methods
    
    override public func viewDidLoad() {
        sceneView.scene = self.scene
        self.view.addSubview(self.sceneView)
        
        // MARK: Configuring scene
        setupScene(self.scene, withView: self.sceneView)
        super.viewDidLoad()
        
        let fontURL = Bundle.main.url(forResource: "Fonts/Megrim", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)

        // MARK: Adding playground title
        self.showPlaygroundTitle()
        
        // MARK: Adding crafted isometric pieces
        for imageInfo in zip(self.builtImages, self.frames) {
            let piece = UIImageView(image: imageInfo.0!)
            piece.frame = imageInfo.1
            piece.alpha = 0
            self.view.addSubview(piece)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                UIView.animate(withDuration: 0.5, animations: {
                    piece.alpha = 1
                })
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
                    piece.transform = CGAffineTransform(translationX: 0.0, y: -10.0)
                })
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                self.addShapeSubtitles()
            })
            
            // MARK: Thank you!
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
                self.showThankYou()
            })
        }        
    }
    
    // MARK: - Helper methods
    
    private func addShapeSubtitles() {
        let shapesSubtitles = ["Rectangle", "Cube inside a cube", "Cropped cube"]
        for subtitle in zip(shapesSubtitles, self.frames) {
            let subLabel = UILabel()
            subLabel.frame = CGRect(x: 0.0, y: 0.0, width: 150.0, height: 200.0)
            subLabel.text = subtitle.0
            
            if subtitle.0 == "Cube inside a cube" {
                subLabel.frame = CGRect(x: subLabel.frame.minX,
                                        y: subLabel.frame.minY,
                                        width: subLabel.frame.width - 20.0,
                                        height: subLabel.frame.height
                )
            } else {
                subLabel.sizeToFit()
            }
            
            subLabel.numberOfLines = 0
            subLabel.textAlignment = .center
            if subtitle.0 == "Cube inside a cube" {
                subLabel.center.y = subtitle.1.maxY + 40.0
            } else {
                subLabel.center.y = subtitle.1.maxY + 30.0
            }
            subLabel.center.x = subtitle.1.midX
            
            subLabel.textColor = UIColor.white
            subLabel.alpha = 0
            self.view.addSubview(subLabel)
            
            UIView.animate(withDuration: 0.5, animations: {
                subLabel.alpha = 1
            })
        }
    }
    
    private func showPlaygroundTitle() {
        let playgroundTitle = UILabel()
        playgroundTitle.frame = CGRect(x: 200.0, y: 175.0, width: 200, height: 100)
        
        playgroundTitle.text = "MOSAIC"
        playgroundTitle.textColor = UIColor.white
        playgroundTitle.font = UIFont(name: "Megrim", size: 50)
        
        self.view.addSubview(playgroundTitle)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            UIView.animate(withDuration: 1.0, animations: {
                playgroundTitle.transform = CGAffineTransform(translationX: 0.0, y: -150.0)
            })
        })
    }
    
    private func showThankYou() {
        let thanks = UILabel()
        thanks.frame = CGRect(x: 215, y: 57.5, width: 400, height: 100)
        thanks.text = "Thank you for playing!"
        thanks.textColor = UIColor.white
        thanks.font = UIFont(name: "HelveticaNeue-Thin", size: 15)
        thanks.alpha = 0

        self.view.addSubview(thanks)
        UIView.animate(withDuration: 0.5, animations: {
            thanks.alpha = 1
        })
    }
}
