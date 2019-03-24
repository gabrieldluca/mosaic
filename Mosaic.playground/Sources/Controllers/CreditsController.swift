import UIKit
import SceneKit

public class CreditsController: UIViewController {
    
    // MARK: - Scene properties
    
    private let scene:SCNScene = SCNScene()
    private let sceneView:SCNView = SCNView()
    
    // MARK: - ViewController Lifecycle methods
    
    override public func viewDidLoad() {
        sceneView.scene = self.scene
        self.view.addSubview(self.sceneView)
        
        // MARK: Configuring scene
        setupScene(self.scene, withView: self.sceneView)
        super.viewDidLoad()
        
        let fontURL = Bundle.main.url(forResource: "Fonts/Megrim", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        
        self.showPlaygroundTitle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.addAttributions()
            self.addNames()
            
            let dismissButton = addToolButton(withImageNamed: "Images/Icons/close.png", andInsets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), toX: 250)
            dismissButton.addTarget(self, action: #selector(self.didPressDismiss(_:)), for: .touchUpInside)
            dismissButton.alpha = 0
            self.view.addSubview(dismissButton)
            
            UIView.animate(withDuration: 0.5, animations: {
                dismissButton.alpha = 1
            })
        })
    }
    
    // MARK: - Helper methods
    
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
    
    private func addAttributions() {
        let texts = ["Design and Code", "Music", "Sound effects", "Pulsator Code"]
        let andY = [150.0, 180.0, 210.0, 335.0]

        for properties in zip(texts, andY) {
            let font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)!
            let label = self.createLabel(withFont: font, text: properties.0, andY: properties.1)
            self.view.addSubview(label)
            
            UIView.animate(withDuration: 0.5, animations: {
                label.alpha = 1
            })
        }
    }
    
    private func addNames() {
        let texts = ["Gabriel D'Luca", "Purple Planet", "soneproject\nBertrof\nGOSFX\nerkanozans\nsanaku\nLloydEvans09", "Shuichi Tsutsumi"]
        let andY = [150.0, 180.0, 255.0, 335.0]
        
        for properties in zip(texts, andY) {
            let font = UIFont(name: "HelveticaNeue-Thin", size: 15.0)!
            let label = self.createLabel(withFont: font, text: properties.0, andY: properties.1)
            self.view.addSubview(label)
            
            UIView.animate(withDuration: 0.5, animations: {
                label.alpha = 1
            })
        }
    }
    
    private func createLabel(withFont: UIFont, text: String, andY: Double) -> UILabel {
        let label = UILabel()
        label.font = withFont
        label.text = text
        label.textColor = UIColor.white
        label.numberOfLines = -1
        label.sizeToFit()
        label.alpha = 0
        
        if withFont.fontName == "HelveticaNeue-Bold" {
            label.textAlignment = .right
            label.frame = CGRect(x: 112.5,
                                 y: label.frame.minY,
                                 width: 150.0,
                                 height: label.frame.height)
        } else {
            label.textAlignment = .left
            label.frame = CGRect(x: 287.5,
                                 y: label.frame.minY,
                                 width: label.frame.width,
                                 height: label.frame.height)
        }
        
        label.center.y = CGFloat(andY)
        return label
    }
    
    @objc private func didPressDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
