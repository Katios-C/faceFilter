import SwiftUI
import iOSDevPackage
import Resolver


struct ContentView: View {
    
    @ObservedObject var arDelegate:ARDelegate = Resolver.resolve()
    
  //  @ObservedObject var recording = Recording()
    @EnvironmentObject private var navigation: NavigationControllerViewModel
    @State var isRecording = false
    @State var url: URL?
    @State var shareVideo = false
    var body: some View {
        ZStack {
          //  ARViewRepresentable(arDelegate: arDelegate)
          
            SelectionOfSmiles()
            
            VStack{
             
                  
                     
                    
                
                Spacer()
                Button{
                    if isRecording {
                        Task {
                            do {
                                self.url = try await stopRecording()
                                isRecording = false
                                shareVideo.toggle()
                            }
                            catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    else{
                    startRecording{ error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        isRecording = true
                    }
                    } }label: {
                    Image(systemName: isRecording ? "record.circle.fill" : "record.circle")
                        .font(.largeTitle)
                        .foregroundColor(isRecording ? .red : .black)
                }
                    .padding(30)
                
            }
            .shareSheet(show: $shareVideo, items: [url])
            
        }
    }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
