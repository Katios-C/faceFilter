import Foundation
import ARKit
import UIKit

class ARDelegate: NSObject, ARSCNViewDelegate, ObservableObject {
    @Published var message:String = "starting AR"
    
    let noseOptions = ["👃", "🐽", "💧", " "]
    let eyeOptions = ["⚽️", "👁", "🌕", "🌟", "🔥", "🔎", " "]
    let mouthOptions = ["👄", "👅", "❤️", " "]
    let hatOptions = ["🎓", "🎩", "🧢", "⛑", "👒", " "]
    let features = ["nose", "leftEye", "rightEye", "mouth", "hat"]
    let featureIndices = [[9], [1064], [42], [24, 25], [20]]
    
    
    func setARView(_ arView: ARSCNView) {
        self.arView = arView
        guard ARFaceTrackingConfiguration.isSupported else { return }
       // let configuration = ARWorldTrackingConfiguration()
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
      //  configuration.planeDetection = .horizontal
        //configuration.isWorldTrackingEnabled
        arView.session.run(configuration)
        
        arView.delegate = self
        arView.scene = SCNScene()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnARView))
//        arView.addGestureRecognizer(tapGesture)
//
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panOnARView))
      //  arView.addGestureRecognizer(panGesture)
    }
    
    

    
//    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
//        print("camera did change \(camera.trackingState)")
//        switch camera.trackingState {
//        case .limited(_):
//            message = "tracking limited"
//        case .normal:
//            message =  "tracking ready"
//        case .notAvailable:
//            message = "cannot track"
//        }
//    }
    
    // MARK: - Private

    private var arView: ARSCNView?
  //  private var circles:[SCNNode] = []
  //  private var trackedNode:SCNNode?
    
    

    func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
      for (feature, indices) in zip(features, featureIndices) {
        let child = node.childNode(withName: feature, recursively: false) as? EmojiNode
        let vertices = indices.map { anchor.geometry.vertices[$0] }
        child?.updatePosition(for: vertices)
        
        switch feature {
        case "leftEye":
          let scaleX = child?.scale.x ?? 1.0
          let eyeBlinkValue = anchor.blendShapes[.eyeBlinkLeft]?.floatValue ?? 0.0
          child?.scale = SCNVector3(scaleX, 1.0 - eyeBlinkValue, 1.0)
        case "rightEye":
          let scaleX = child?.scale.x ?? 1.0
          let eyeBlinkValue = anchor.blendShapes[.eyeBlinkRight]?.floatValue ?? 0.0
          child?.scale = SCNVector3(scaleX, 1.0 - eyeBlinkValue, 1.0)
        case "mouth":
          let jawOpenValue = anchor.blendShapes[.jawOpen]?.floatValue ?? 0.2
          child?.scale = SCNVector3(1.0, 0.8 + jawOpenValue, 1.0)
        default:
          break
        }
      }
    }
    
    
   
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
      guard let faceAnchor = anchor as? ARFaceAnchor,
            let device = arView?.device else { return nil }
      let faceGeometry = ARSCNFaceGeometry(device: device)
      let node = SCNNode(geometry: faceGeometry)
      node.geometry?.firstMaterial?.fillMode = .lines
      
      node.geometry?.firstMaterial?.transparency = 0.0
      let noseNode = EmojiNode(with: noseOptions)
      noseNode.name = "nose"
      node.addChildNode(noseNode)
      
      let leftEyeNode = EmojiNode(with: eyeOptions)
      leftEyeNode.name = "leftEye"
      leftEyeNode.rotation = SCNVector4(0, 1, 0, GLKMathDegreesToRadians(180.0))
      node.addChildNode(leftEyeNode)
      
      let rightEyeNode = EmojiNode(with: eyeOptions)
      rightEyeNode.name = "rightEye"
      node.addChildNode(rightEyeNode)
      
      let mouthNode = EmojiNode(with: mouthOptions)
      mouthNode.name = "mouth"
      node.addChildNode(mouthNode)
      
      let hatNode = EmojiNode(with: hatOptions)
      hatNode.name = "hat"
      node.addChildNode(hatNode)
      
      updateFeatures(for: node, using: faceAnchor)
      return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
      guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
      
      faceGeometry.update(from: faceAnchor.geometry)
      updateFeatures(for: node, using: faceAnchor)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
      let location = sender.location(in: arView)
        let results = arView!.hitTest(location, options: nil)
      if let result = results.first,
        let node = result.node as? EmojiNode {
        node.next()
      }
    }
    
    }
    


