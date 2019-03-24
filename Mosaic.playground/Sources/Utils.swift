import AVFoundation
import SceneKit
import UIKit

// MARK: Angle Conversion helper

public var angleForNumber = [
    0:Double.pi/2,
    1:Double.pi,
    2:Double.pi*1.5,
    3:Double.pi*2.0
]

// MARK: - Level Setup helpers

/**
 Add a simple header with a dark translucid background
 
 - Parameter toView: The view to add the header to.
 */
public func addHeader(toView: UIView) {
    let header = UIView()
    header.frame = CGRect(x: 125, y: 25, width: 300, height: 125)
    header.backgroundColor = UIColor(red:0.21, green:0.20, blue:0.28, alpha:0.3)
    header.layer.cornerRadius = 7.5
    toView.addSubview(header)
}

/**
 Creates a description label aligned to the top-part of a view.
 
 - Parameter toView: The view to add the description to.
 - Parameter withText: A string representing the text of the desired description.

 - returns: UILabel
 */
public func addDescription(toView: UIView, withText: String) -> UILabel {
    let text = UILabel()
    text.text = withText
    text.frame = CGRect(x: 140, y: 35, width: 275, height: 100)
    text.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
    
    text.textAlignment = NSTextAlignment.center
    text.textColor = UIColor.white
    text.numberOfLines = 4
    text.lineBreakMode = NSLineBreakMode.byTruncatingTail
    
    toView.addSubview(text)
    return text
}

/**
 Creates translucid circle with a number representing the current level.

 - Parameter toView: The view to add the level number to.
 - Parameter withText: A string representing the text of the desired level number.
 */
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

// MARK: - Level Teardown helper

/**
 Creates a label with an author name attribution. The label is created with zero alpha for animation purposes.
 
 - Parameter withAuthor: A string representing the author name.
 - Parameter toView: The view to add the attribution below.
 
 - returns: UILabel
 */
public func createReference(withAuthor: String, relativeTo: UILabel) -> UILabel {
    let quote = UILabel(frame: CGRect(x: relativeTo.frame.minX, y: relativeTo.frame.midY - 15, width: relativeTo.frame.width, height: relativeTo.frame.height))
    quote.text = withAuthor
    quote.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
    quote.textColor = UIColor.white
    quote.textAlignment = .center
    quote.alpha = 0
    
    if withAuthor == "— Ellen Langer —" {
        quote.transform = CGAffineTransform.init(translationX: 0, y: 9.0)
    }
    
    return quote
}

// MARK: - Interface Buttons helpers

/**
 Creates an interactive button.
 
 - Parameter withImageNamed: A string containing the path of the image.
 - Parameter andInsets: Insets properties to keep the image proportion.
 - Parameter toX: The desired position in the X coordinate.
 
 - returns: UIButton
 */
public func addToolButton(withImageNamed: String, andInsets: UIEdgeInsets, toX: Double) -> UIButton {
    let toolButton = UIButton(frame: CGRect(x: toX, y: 387.5, width: 50, height: 50))
    toolButton.setImage(UIImage(named: withImageNamed), for: .normal)
    
    toolButton.setBackgroundColor(color: UIColor(red:0.21, green:0.20, blue:0.28, alpha:0.3), forState: .normal)
    toolButton.setBackgroundColor(color: UIColor(red:0.57, green:0.36, blue:0.97, alpha:1.0), forState: .selected)
    
    toolButton.layer.cornerRadius = toolButton.frame.height/2
    toolButton.layer.masksToBounds = true
    toolButton.imageEdgeInsets = andInsets
    
    return toolButton
}

// MARK: - SceneKit helpers

/**
 Add a particle emitter node.
 
 - Parameter toScene: The scene to add the particle emitter to.
 - Parameter withParticle: The desired particle.
 - Parameter inFrontOf: The node to position the particles in front of.
 */
public func addEmmiterNode(toScene: SCNScene, withParticle: SCNParticleSystem?, inFrontOf: SCNNode) {
    let particleEmitter = SCNNode()
    if let particles = withParticle {
        particleEmitter.addParticleSystem(particles)
    }
    
    toScene.rootNode.addChildNode(particleEmitter)
    
    // MARK: Adding the emitter node 3 meters in front of other node
    let position = SCNVector3(x: 0, y: 0, z: 3)
    updatePositionAndOrientationOf(particleEmitter, withPosition: position, relativeTo: inFrontOf)
}

/**
 Setup a non-interactive scene with stars in the background.
 
 - Parameter scene: The scene to place the camera, lights and particles to.
 - Parameter withView: The view to add configurations to.
 */
public func setupScene(_ scene: SCNScene, withView: SCNView) {
    withView.frame = CGRect(x:0, y:0, width:550, height:450)
    withView.allowsCameraControl = false
    withView.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.14, alpha:1.0)
    
    // MARK: Placing the camera and adding lights
    let camera = scene.placeCamera()
    scene.addLight()
    scene.addAmbientLight()
    
    // MARK: Adding a star emitter node
    let stars = SCNParticleSystem(named: "Particle Systems/starry-night.scnp", inDirectory: nil)
    addEmmiterNode(toScene: scene, withParticle: stars, inFrontOf: camera)
}

/**
 Places a node in a specific position in front of another node.
 
 - Parameter node: The node you want to position.
 - Parameter position: The desired position coordinates (x, y, z).
 - Parameter referenceNode: The other node you want to use as a reference.
 */
public func updatePositionAndOrientationOf(_ node: SCNNode, withPosition position: SCNVector3, relativeTo referenceNode: SCNNode) {
    
    // MARK: Setup a translation matrix with the desired position
    var translationMatrix = matrix_identity_float4x4
    translationMatrix.columns.3.x = position.x
    translationMatrix.columns.3.y = position.y
    translationMatrix.columns.3.z = position.z

    // MARK: Multiplying the reference node by the translation matrix
    let referenceNodeTransform = matrix_float4x4(referenceNode.transform)
    let updatedTransform = matrix_multiply(referenceNodeTransform, translationMatrix)
    
    // MARK: Updating node
    node.transform = SCNMatrix4(updatedTransform)
}
