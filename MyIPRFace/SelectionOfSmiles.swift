import SwiftUI
import Resolver
import iOSDevPackage

struct SelectionOfSmiles: View {
    
    @EnvironmentObject private var navigation: NavigationControllerViewModel
    
    
    @State private var selectedEyes = " "
    @State private var selectedLips = " "
    @State private var selectedNose = " "
    
    var body: some View {
        ZStack{
            ARViewStart(eyeString: $selectedEyes, noseString: $selectedNose, lipstring: $selectedLips)
                .blur(radius: 10)
            VStack {
                RectangleSelectionView(selectedE: $selectedEyes, selectedL: $selectedLips, selectedN: $selectedNose)

                Button(""){
                    navigation.push(ARViewStart(eyeString: $selectedEyes, noseString: $selectedNose, lipstring: $selectedLips))
                }
                .buttonStyle(BlueButton())
            }
        }
        .padding()
    }
}

