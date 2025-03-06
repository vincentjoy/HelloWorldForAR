// Build a TV screen object in real world

import UIKit
import RealityKit
import AVKit
import ARKit

class TVScreenVC: UIViewController {
    
    @IBOutlet var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start off plane detection
        startPlaneDetection()
        
        startTapDetection()
    }
    
    func startPlaneDetection() {
        arView.automaticallyConfigureSession = true
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        
        arView.session.run(configuration)
    }
    
    func startTapDetection() {
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recogonizer:))))
    }
    
    @objc func handleTap(recogonizer: UITapGestureRecognizer) {
        let tapLocation = recogonizer.location(in: arView)
        
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        if let firstResult = results.first {
            
            // 3D point
            let worldPosition = simd_make_float3(firstResult.worldTransform.columns.3)
            
            // Place screen at 3D point
            if let videoScreen = createVideoScreen(width: 0.4, height: 0.2) {
                videoScreen.setPosition(SIMD3(x:0, y:0.2/2, z:0), relativeTo: videoScreen) // y position is like that, to lift the video screen little above the plane, so no part of it will be going under the table
                placeScreen(videoScreen, at: worldPosition)
                
                // Enable gestures
                installGestures(on: videoScreen)
            }
        }
    }
    
    func placeScreen(_ screen: ModelEntity, at worldPosition: SIMD3<Float>) {
        
        // Anchor
        let anchor = AnchorEntity(world: worldPosition)
        
        // Tie model to anchor
        anchor.addChild(screen)
        
        // Anchor to scene
        arView.scene.addAnchor(anchor)
    }
    
    func installGestures(on model: ModelEntity) {
        model.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .scale], for: model)
    }
    
    // MARK:- Video Screen
    func createVideoScreen(width: Float, height: Float) -> ModelEntity? {
        
        // Mesh
        let screenMesh = MeshResource.generatePlane(width: width, height: height)
        
        // Video Material
        let url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        guard let videoItem = createVideoItem(with: url) else { return nil }
        let videoMaterial = createVideoMaterial(with: videoItem)
        
        // Model entity
        let videoScreenEntity = ModelEntity(mesh: screenMesh, materials: [videoMaterial])
        
        return videoScreenEntity
    }
    
    func createVideoItem(with urlString: String) -> AVPlayerItem? {
        
        // URL
        guard let url = URL(string: urlString) else { return nil }
        
        // Video Item
        let asset = AVURLAsset(url: url)
        let videoItem = AVPlayerItem(asset: asset)
        
        return videoItem
    }
    
    func createVideoMaterial(with videoItem: AVPlayerItem) -> VideoMaterial {
        
        // Player
        let player = AVPlayer()
        let videoMaterial = VideoMaterial(avPlayer: player)
        
        // Play video
        player.replaceCurrentItem(with: videoItem)
        player.play()
        
        return videoMaterial
    }
}
