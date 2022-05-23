import ARKit
import SwiftUI

struct ARViewRepresentable: UIViewRepresentable {
    let arDelegate:ARDelegate
    
    func makeUIView(context: Context) -> some UIView {
        
////        guard ARFaceTrackingConfiguration.isSupported else { return }
//        let configuration = ARFaceTrackingConfiguration()
//        if #available(iOS 13.0, *) {
//            configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
//        }
//        configuration.isLightEstimationEnabled = true
////        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        
        let arView = ARSCNView(frame: .zero)
        arDelegate.setARView(arView)
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct ARViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        ARViewRepresentable(arDelegate: ARDelegate())
    }
}
