import SwiftUI
import iOSDevPackage

struct StartVideoView: View {
    
    @EnvironmentObject private var navigation: NavigationControllerViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Button("Start Video") {
                navigation.push(ContentView())
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(20)
        }
    }
}

struct StartVideoView_Previews: PreviewProvider {
    static var previews: some View {
        StartVideoView()
    }
}
