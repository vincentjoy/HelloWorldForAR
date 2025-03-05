//
//  RotateAndScaleVC.swift
//  HelloWorldForAR
//
//  Created by Vincent Joy on 05/03/25.
//

import UIKit
import RealityKit

class RotateAndScaleVC: UIViewController {
    
    @IBOutlet var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Create box
        let box = createBox()
        
        // 2. Place sphere
        placeBox(box, at: SIMD3(x: 0, y: 0, z: 0))
        
        // 3. Install gestures
        installGestures(on: box)
    }
    
    private func createBox() -> ModelEntity {
        let boxShape = MeshResource.generateBox(size: 0.5)
        let boxMaterial = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
        let boxEntity = ModelEntity(mesh: boxShape, materials: [boxMaterial])
        return boxEntity
    }
    
    private func placeBox(_ box: ModelEntity, at position: SIMD3<Float>) {
        
        // Anchor
        let boxAnchor = AnchorEntity(world: position)
        boxAnchor.addChild(box)
        
        arView.scene.anchors.append(boxAnchor)
    }
    
    private func installGestures(on object: ModelEntity) {
        object.generateCollisionShapes(recursive: true) // Adding collision boxes around the 3D objects for gestures to work
        arView.installGestures([.rotation, .scale], for: object)
    }
}
