import SwiftUI
import iOSDevPackage


@main
struct MyIPRFaceApp: App {

    var body: some Scene {
        WindowGroup {
            NavigationControllerView(transition: .custom(.slide, .slide)) {
            StartVideoView()
        }
    }
}
}
