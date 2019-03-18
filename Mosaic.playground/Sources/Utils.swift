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

// MARK: - Level setup Helpers

public func addHeader(toView: UIView) {
    let header = UIView()
    header.frame = CGRect(x: 125, y: 25, width: 300, height: 125)
    header.backgroundColor = UIColor(red:0.21, green:0.20, blue:0.28, alpha:0.3)
    header.layer.cornerRadius = 7.5
    toView.addSubview(header)
}

public func addDescription(toView: UIView, withText: String) {
    let text = UILabel()
    text.text = withText
    text.frame = CGRect(x: 140, y: 35, width: 275, height: 100)
    text.font = UIFont(name: "HelveticaNeue-Medium", size: 16)

    text.textAlignment = NSTextAlignment.center
    text.textColor = UIColor.white
    text.numberOfLines = 2
    text.lineBreakMode = NSLineBreakMode.byTruncatingTail

    toView.addSubview(text)
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

// MARK: - Speech to Text

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
