import SceneKit

extension SCNScene {
    /**
     Places a camera in the scene, returning the generated camera node.
     
     - returns: SCNNode
     */
    func placeCamera() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        self.rootNode.addChildNode(cameraNode)
        return cameraNode
    }
    
    /**
     Add an omni light in the scene.
     */
    func addLight() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        self.rootNode.addChildNode(lightNode)
    }
    
    /**
     Add a dark-gray ambient light in the scene.
     */
    func addAmbientLight() {
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        self.rootNode.addChildNode(ambientLightNode)
    }
}
