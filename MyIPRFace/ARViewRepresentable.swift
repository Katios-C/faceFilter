import ARKit
import SwiftUI

struct ARViewRepresentable: UIViewRepresentable {
    let arDelegate:ARDelegate
    let eyeString: String
    let noseString: String
    let lipsString: String
    
    func makeUIView(context: Context) -> some UIView {
        
        let arView = ARSCNView(frame: .zero)
        arDelegate.setARView(arView, eye: eyeString, nose: noseString, lips: lipsString)
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

