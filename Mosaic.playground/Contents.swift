/*:
 # Mosaic
 ![Playground Icon](Assets/logo.png width="275" height="249")
 
 Mosaic is an interactive Swift playground that portrays the relationship between isometric shapes and visual perception. You may build and interact with it in the latest release of XCode.
 
 The list of modules and frameworks I've used include:
 
 * **UIKit:** Lorem Ipsum dolor sit amet.
 * **SpriteKit:** Lorem Ipsum dolor sit amet.
 * **SceneKit:** Lorem Ipsum dolor sit amet.
 * **AVFoundation:** Lorem Ipsum dolor sit amet.
 */

import UIKit
import PlaygroundSupport
import AVFoundation
import SceneKit

var player:AVAudioPlayer = AVAudioPlayer()
do {
    
    /*
     Royalty free music from Bensound.com (https://www.bensound.com/licensing)
     */
    let audioPath = Bundle.main.path(forResource: "Sound/perception", ofType: "mp3")
    try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
} catch {
    print("Couldn't find background music file.")
}

player.numberOfLoops = -1
player.prepareToPlay()
player.play()

public class IntroController: UIViewController {
    
    private let scene:SCNScene = SCNScene()
    private let sceneView:SCNView = SCNView()
    
    override public func viewDidLoad() {
        let sceneView = self.sceneView
        sceneView.scene = self.scene
        
        let camera = placeCamera(toScene: self.scene)
        addLight(toScene: self.sceneView.scene!)
        addAmbientLight(toScene: self.sceneView.scene!)
        
        self.sceneView.frame = CGRect(x:0, y:0, width:550, height:450)
        self.sceneView.allowsCameraControl = true
        self.sceneView.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.14, alpha:1.0)
        
        let stars = SCNParticleSystem(named: "Particles/stars.scnp", inDirectory: nil)
        let particleEmitter = SCNNode()
        if let particles = stars {
            particleEmitter.addParticleSystem(particles)
        }
        
        self.scene.rootNode.addChildNode(particleEmitter)
        let position = SCNVector3(x: 0, y: 0, z: 3)
        updatePositionAndOrientationOf(particleEmitter, withPosition: position, relativeTo: camera)
        
        self.view.addSubview(self.sceneView)
        
        let images = [UIImage(named: "Assets/intro-0.png"),
                      UIImage(named: "Assets/intro-1.png"),
                      UIImage(named: "Assets/intro-2.png"),
                      UIImage(named: "Assets/intro-3.png")]
        let frames = [CGRect(x: 50, y: 75, width: 55, height: 54),
                      CGRect(x: 465, y: 75, width: 25, height: 43.76),
                      CGRect(x: 75, y: 300, width: 55, height: 54),
                      CGRect(x: 400, y: 350, width: 55, height: 54)]
        
        var animationViews:[UIImageView] = []
        for imageInfo in zip(images, frames) {
            let view = UIImageView(image: imageInfo.0)
            view.frame = imageInfo.1
            animationViews.append(view)
        }
        
        var delta = 3.0
        for view in animationViews {
            UIView.animate(withDuration: 7.5, delay: 0, options: [.repeat, .autoreverse], animations: {
                view.transform = view.transform.rotated(by: CGFloat(Double.pi/18.0 * delta))
            })
            delta *= 2
            self.view.addSubview(view)
        }
    }
}


let viewController = IntroController()
viewController.preferredContentSize = CGSize(width: 550, height: 450)
PlaygroundPage.current.liveView = viewController

var speechSynthesizer = AVSpeechSynthesizer()
// Line 2. Create an instance of AVSpeechUtterance and pass in a String to be spoken.
var speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: "Press start to begin.")
//Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
speechUtterance.rate = 0.5
speechUtterance.volume = 1
// Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
speechUtterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Daniel-compact")
// Line 5. Pass in the urrerance to the synthesizer to actually speak.
speechUtterance.pitchMultiplier = 1.5

DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
    player.volume = 0.25
    speechSynthesizer.speak(speechUtterance)
})

DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
    player.volume = 1
})
