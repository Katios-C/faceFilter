import SwiftUI
import iOSDevPackage


struct ContentView: View {
    
    @ObservedObject var arDelegate = ARDelegate()
  //  @ObservedObject var recording = Recording()
    @EnvironmentObject private var navigation: NavigationControllerViewModel
    
    var body: some View {
        ZStack {
            ARViewRepresentable(arDelegate: arDelegate)
            
            VStack {
                HStack {
                    ZStack {
                        Button("") {
                            
                        }
                        
                        .frame(width: 60, height: 60)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        Image(systemName: "arrowshape.turn.up.backward")
                            .aspectRatio(contentMode: .fit)
                        
                    }
                    .padding(.top, 40)
                    .padding(20)
                    .onTapGesture {
                        navigation.pop(to: .previous)
                    }
                    Spacer()
                }
                
                Spacer()
                HStack {
                    Button("Start") {
                        arDelegate.startRecording()
                      //  recording.startRecording()
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding(.horizontal)
                    .padding(20)
                    Button("Save") {
                        arDelegate.stopRecording()
                      //  recording.stopRecording()
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding(.horizontal)
                    .padding(20)
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
