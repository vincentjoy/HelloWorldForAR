// Build a TV screen object in real world

import UIKit
import RealityKit
import AVKit

class TVScreenVC: UIViewController {
    
    @IBOutlet var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()
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
