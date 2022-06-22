import SwiftUI
import iOSDevPackage
import ARKit

@main
struct MyIPRFaceApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationControllerView(transition: .custom(.slide, .slide)) {
                if ARFaceTrackingConfiguration.isSupported {
                SelectionOfSmiles()
                } else {
                    Text("Face tracking is not supported on this device")
                }
        }
    }
}
}
