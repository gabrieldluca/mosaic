import AVFoundation
import SceneKit
import UIKit

public func addQuote(text: String, toView: UIView, color: UIColor, frame: CGRect) -> UILabel {
    let quote = UILabel()
    quote.text = text
    quote.textColor = color
    quote.frame = frame
    quote.alpha = 0
    quote.font = UIFont(name: "HelveticaNeue-Thin", size: CGFloat(25.0))
    toView.addSubview(quote)
    return quote
}

// MARK: Angle conversion

public var angleForNumber = [
    0:Double.pi/2,
    1:Double.pi,
    2:Double.pi*1.5,
    3:Double.pi*2.0
]

// MARK: - Level setup Helpers

public func addHeader(toView: UIView) {
    let header = UIView()
    header.frame = CGRect(x: 125, y: 25, width: 300, height: 125)
    header.backgroundColor = UIColor(red:0.21, green:0.20, blue:0.28, alpha:0.3)
    header.layer.cornerRadius = 7.5
    toView.addSubview(header)
}

public func addDescription(toView: UIView, withText: String) -> UILabel {
    let text = UILabel()
    text.text = withText
    text.frame = CGRect(x: 140, y: 35, width: 275, height: 100)
    text.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
    
    text.textAlignment = NSTextAlignment.center
    text.textColor = UIColor.white
    text.numberOfLines = 2
    text.lineBreakMode = NSLineBreakMode.byTruncatingTail
    
    toView.addSubview(text)
    return text
}

public func addLevelNumber(toView: UIView, withText: String) {
    let number = UILabel()
    number.text = withText
    number.frame = CGRect(x: 260, y: 130, width: 35, height: 35)
    number.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
    
    number.textAlignment = NSTextAlignment.center
    number.textColor = UIColor.white
    number.backgroundColor = UIColor(red:0.64, green:0.62, blue:0.88, alpha:0.5)
    number.layer.cornerRadius = number.frame.height/2
    number.layer.masksToBounds = true
    
    toView.addSubview(number)
}

public func addNextButton(toView: UIView) -> UIButton {
    let nextButton = UIButton()
    //number.text = withText
    nextButton.frame = CGRect(x: 260, y: 130, width: 35, height: 35)
    nextButton.setImage(UIImage(named: "Images/Icons/next.png"), for: .normal)
    nextButton.imageEdgeInsets = UIEdgeInsets(top: 7.5, left: 9.5, bottom: 7.5, right: 9.5)
    
    //number.textAlignment = NSTextAlignment.center
    //number.textColor = UIColor.white
    nextButton.setBackgroundColor(color: UIColor(red:0.64, green:0.62, blue:0.88, alpha:0.5), forState: .normal)
    nextButton.setBackgroundColor(color: UIColor(red:0.21, green:0.20, blue:0.28, alpha:0.3), forState: .selected)
    
    nextButton.layer.cornerRadius = nextButton.frame.height/2
    nextButton.layer.masksToBounds = true
    
    toView.addSubview(nextButton)
    return nextButton
}

// MARK: - Interface button methods

public func addToolButton(withImageNamed: String, andInsets: UIEdgeInsets, toX: Double) -> UIButton {
    let toolButton = UIButton(frame: CGRect(x: toX, y: 387.5, width: 50, height: 50))
    toolButton.setImage(UIImage(named: withImageNamed), for: .normal)
    
    toolButton.setBackgroundColor(color: UIColor(red:0.21, green:0.20, blue:0.28, alpha:0.3), forState: .normal)
    toolButton.setBackgroundColor(color: UIColor(red:0.57, green:0.36, blue:0.97, alpha:1.0), forState: .selected)
    
    toolButton.layer.cornerRadius = toolButton.frame.height/2
    toolButton.layer.masksToBounds = true
    toolButton.imageEdgeInsets = andInsets // UIEdgeInsets(top: 10, left: 11.21, bottom: 10, right: 11.21)
    // UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    
    return toolButton
}

/**
 Creates a quote-formatted label with zero alpha for Animation purposes.
 
 - Parameter text: A string representing the text of the desired quote.
 - Parameter toView: The view to add the quote to.
 - Parameter color: The color of the quote.
 - Parameter frame: A frame containing the coordinates and the dimensions for the quote.
 
 - returns: UILabel
 */

// MARK: - SceneKit Helpers

public func addEmmiterNode(toScene: SCNScene, withParticle: SCNParticleSystem?, inFrontOf: SCNNode) {
    let particleEmitter = SCNNode()
    if let particles = withParticle {
        particleEmitter.addParticleSystem(particles)
    }
    
    toScene.rootNode.addChildNode(particleEmitter)
    let position = SCNVector3(x: 0, y: 0, z: 3)
    updatePositionAndOrientationOf(particleEmitter, withPosition: position, relativeTo: inFrontOf)
}

public func setupScene(_ scene: SCNScene, withView: SCNView) {
    withView.frame = CGRect(x:0, y:0, width:550, height:450)
    withView.allowsCameraControl = false
    withView.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.14, alpha:1.0)
    
    let camera = scene.placeCamera()
    scene.addLight()
    scene.addAmbientLight()
    
    let stars = SCNParticleSystem(named: "Particle Systems/starry-night.scnp", inDirectory: nil)
    addEmmiterNode(toScene: scene, withParticle: stars, inFrontOf: camera)
}

public func updatePositionAndOrientationOf(_ node: SCNNode, withPosition position: SCNVector3, relativeTo referenceNode: SCNNode) {
    let referenceNodeTransform = matrix_float4x4(referenceNode.transform)
    
    // Setup a translation matrix with the desired position
    var translationMatrix = matrix_identity_float4x4
    translationMatrix.columns.3.x = position.x
    translationMatrix.columns.3.y = position.y
    translationMatrix.columns.3.z = position.z

    let updatedTransform = matrix_multiply(referenceNodeTransform, translationMatrix)
    node.transform = SCNMatrix4(updatedTransform)
}
