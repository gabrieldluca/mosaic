import AVFoundation
import UIKit
import SceneKit

/**
 Creates a quote-formatted label with zero alpha for Animation purposes.
 
 - Parameter text: A string representing the text of the desired quote.
 - Parameter toView: The view to add the quote to.
 - Parameter color: The color of the quote.
 - Parameter frame: A frame containing the coordinates and the dimensions for the quote.
 
 - returns: UILabel
 */
public func addLabel(text: String, toView: UIView, color: UIColor, frame: CGRect) -> UILabel {
    let quote = UILabel()
    quote.text = text
    quote.textColor = color
    quote.frame = frame
    quote.alpha = 0
    quote.font = UIFont(name: "HelveticaNeue-Thin", size: CGFloat(25.0))
    toView.addSubview(quote)
    return quote
}

/**
 Creates a bezier path from pair (405, 400) to the desired point.
 
 - Parameter point: A CGPoint containing the x and y coordinates.
 
 - returns: CGPath
 */
public func setLine(point: CGPoint) -> CGPath {
    let bezier = UIBezierPath()
    bezier.move(to: CGPoint(x: 405, y: 400))
    bezier.addLine(to: point)
    return bezier.cgPath
}

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
    
    // Combine the configured translation matrix with the referenceNode's transform to get the desired position AND orientation
    let updatedTransform = matrix_multiply(referenceNodeTransform, translationMatrix)
    node.transform = SCNMatrix4(updatedTransform)
}

// MARK: - Speech To Text
public func synthesizeSpeech(forString: String, whilePlaying: AVAudioPlayer) {
    let speechSynthesizer = AVSpeechSynthesizer()
    let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: forString)
    speechUtterance.rate = 0.5
    speechUtterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Daniel-compact")
    speechUtterance.pitchMultiplier = 1.5
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
        whilePlaying.volume = 0.25
        speechSynthesizer.speak(speechUtterance)
    })
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
        whilePlaying.volume = 1
    })
}
