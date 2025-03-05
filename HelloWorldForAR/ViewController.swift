//
//  ViewController.swift
//  HelloWorldForAR
//
//  Created by Vincent Joy on 05/03/25.
//

import UIKit
import SceneKit
import ARKit
import RealityKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 3D Model
        let sphere = MeshResource.generateSphere(radius: 0.05)
        let material = SimpleMaterial(color: .red, roughness: 0, isMetallic: true)
        
        let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
        
        // 2. Create anchor
        let sphereAnchor = AnchorEntity(world: SIMD3(x: 0, y: 0, z: 0))
        sphereAnchor.addChild(sphereEntity)
        
        // 3. Add anchor to scene
        arView.scene.addAnchor(sphereAnchor)
    }
}
