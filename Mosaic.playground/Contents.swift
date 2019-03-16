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
//player.play()

let viewController = IntroController()
viewController.preferredContentSize = CGSize(width: 550, height: 450)
PlaygroundPage.current.liveView = viewController

synthesizeSpeech(forString: "Press start to begin.", whilePlaying: player)
