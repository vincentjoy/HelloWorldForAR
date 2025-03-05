// Here we are gonna add the features -
// Plane detection (Horizonatal plane in this case)
// Adding sphere to that plane

import UIKit
import RealityKit
import ARKit

class PlaneDetectionVC: UIViewController {
    
    @IBOutlet var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Fire off plane detection
        startPlaneDetection()
        
        // 2. Get 2D point
        // Get access to that plane and place virtual objects on that
        // Detect touches on the screen and get the touches to the location, which will later convert to 3D point using raycasting
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recogonizer:))))
    }
    
    @objc func handleTap(recogonizer: UITapGestureRecognizer) {
        
        // Touch location
        let tapLocation = recogonizer.location(in: arView)
        
        // Raycast 2D to 3D
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstPlane = results.first { // This would be the first plane Ray intersected with
            // 3D point (x, y, z) of the touch
            let worldPos = simd_make_float3(firstPlane.worldTransform.columns.3) // Takes the 3D position from the first ray cast result and convert that into 3D vector
            
            // Create sphere
            let sphere = createSphere()
            
            // Place the sphere
            placeObject(sphere, at: worldPos)
        }
    }
    
    func startPlaneDetection() {
        arView.automaticallyConfigureSession = true
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic // Makes the whole lighting and rendering more realisitc
        
        arView.session.run(configuration)
    }
    
    func createSphere() -> ModelEntity {
        // Mesh
        let sphere = MeshResource.generateSphere(radius: 0.5)
        
        // Assign material
        let sphereMaterial = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
        
        // Model entity
        let sphereEntity = ModelEntity(mesh: sphere, materials: [sphereMaterial])
        
        return sphereEntity
    }
    
    func placeObject(_ object: ModelEntity, at location: SIMD3<Float>) {
        // 1. Create an anchor which locks a virtual object to a specific place in real world
        let objectAnchor = AnchorEntity(world: location)
        
        // 2. Tie model to the anchor
        objectAnchor.addChild(object)
        
        // 3. Add anchor to scene
        arView.scene.anchors.append(objectAnchor)
    }
}
