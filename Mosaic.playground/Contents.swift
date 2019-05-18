/*:
 # Mosaic
 ![Playground Icon](Images/logo.png width="275" height="249")
 
 ### 🤯 About

 Mosaic is an interactive puzzle game that explores isometric shapes, design principles and visual perception.
 
 * Callout(Purpose):
 The purpose of this playground is teaching the properties of isometric shapes in a mind-blowing way, following the *"Write code, blow minds"* motto.
 
 ### 🧩 Gameplay

 In each level, you will face a challenge, and must interact and fit different pieces to complete the objective. Actions include moving, rotating, scaling and colorizing.
 
 ### 💻 Requirements
 
 You may build and interact with Mosaic in the latest release of XCode (10.1).
 
 ---
 */
import PlaygroundSupport
import AVFoundation

var player:AVAudioPlayer = AVAudioPlayer()
do {
    /*
     "Hybrid Tech Theme" by Purple Planet
     
     Source: https://www.purple-planet.com/atmospheric
     Music: https://www.purple-planet.com (CC-BY 3.0: https://www.purple-planet.com/using-our-free-music)
     */
    let audioPath = Bundle.main.path(forResource: "Sound/hybrid-tech-theme", ofType: "mp3")
    try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
} catch {
    print("Couldn't find background music file.")
}

player.numberOfLoops = -1
player.prepareToPlay()
player.play()

let viewController = IntroController()
viewController.preferredContentSize = CGSize(width: 550, height: 450)
PlaygroundPage.current.liveView = viewController
