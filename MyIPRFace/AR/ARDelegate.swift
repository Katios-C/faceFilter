import Foundation
import ARKit
import SwiftUI
import CoreMedia
import AVFoundation
import Photos
import Resolver

class ARDelegate: NSObject, ARSCNViewDelegate, ObservableObject, AVCaptureAudioDataOutputSampleBufferDelegate {
  
    private var arView: ARSCNView?
    private var isRecording:Bool = false
    private var snapshotArray:[[String:Any]] = [[String:Any]]()
    private var lastTime:TimeInterval = 0
    private var videoStartTime:CMTime?
    
    private var eyeString = ""
    private var noseString = ""
    private var lipString = ""
    
    let features = ["nose", "leftEye", "rightEye", "mouth", "hat"]
    let featureIndices = [[9], [1064], [42], [24, 25], [20]]
    
    
    // Asset Writer
    var pixelBufferAdaptor:AVAssetWriterInputPixelBufferAdaptor?
    var videoInput:AVAssetWriterInput?
    var audioInput:AVAssetWriterInput?
    var assetWriter:AVAssetWriter?
    

    
    func setARView(_ arView: ARSCNView, eye: String, nose: String, lips: String) {
        self.arView = arView
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration)
        
        arView.delegate = self
        arView.scene = SCNScene()
        
        eyeString = eye
        noseString = nose
        lipString = lips

    }
    

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
        let noseNode = EmojiNode(with: noseString)
        noseNode.name = "nose"
        node.addChildNode(noseNode)
        
        let leftEyeNode = EmojiNode(with: eyeString)
        leftEyeNode.name = "leftEye"
        leftEyeNode.rotation = SCNVector4(0, 1, 0, GLKMathDegreesToRadians(180.0))
        node.addChildNode(leftEyeNode)
        
        let rightEyeNode = EmojiNode(with: eyeString)
        rightEyeNode.name = "rightEye"
        node.addChildNode(rightEyeNode)
        
        let mouthNode = EmojiNode(with: lipString)
        mouthNode.name = "mouth"
        node.addChildNode(mouthNode)
                
        updateFeatures(for: node, using: faceAnchor)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
        
        faceGeometry.update(from: faceAnchor.geometry)
        updateFeatures(for: node, using: faceAnchor)
    }
}



