import SceneKit

extension SCNScene {
    /**
     Places a camera in the respective scene.
     
     - Parameter toScene: The desired scene object to place the camera to.
     
     - returns: SCNNode
     */
    func placeCamera() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        self.rootNode.addChildNode(cameraNode)
        return cameraNode
    }
    
    /**
     Add an omni light to the respective scene.
     
     - Parameter toScene: The desired scene object to add the light to.
     */
    func addLight() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        self.rootNode.addChildNode(lightNode)
    }
    
    /**
     Add a dark-gray ambient light to the respective scene.
     
     - Parameter toScene: The desired scene object to add the ambient light to.
     */
    func addAmbientLight() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        self.rootNode.addChildNode(ambientLightNode)
    }
}
