import SwiftUI
import iOSDevPackage


struct ContentView: View {
    
    @ObservedObject var arDelegate = ARDelegate()
  //  @ObservedObject var recording = Recording()
    @EnvironmentObject private var navigation: NavigationControllerViewModel
    @State var isRecording = false
    @State var url: URL?
    @State var shareVideo = false
    var body: some View {
        ZStack {
            ARViewRepresentable(arDelegate: arDelegate)
          //  .overlay(alignment: .bottomTrailing) {
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
            
//            VStack {
//                HStack {
//                    ZStack {
//                        Button("") {
//
//                        }
//
//                        .frame(width: 60, height: 60)
//                        .background(Color.orange)
//                        .foregroundColor(.white)
//                        .clipShape(Circle())
//                        Image(systemName: "arrowshape.turn.up.backward")
//                            .aspectRatio(contentMode: .fit)
//
//                    }
//                    .padding(.top, 40)
//                    .padding(20)
//                    .onTapGesture {
//                        navigation.pop(to: .previous)
//                    }
//                    Spacer()
//                }
//
//                Spacer()
//                HStack {
//                    Button("Start") {
//                        arDelegate.startRecording()
//                      //  recording.startRecording()
//
//                    }
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
//                    .background(Color.orange)
//                    .foregroundColor(.white)
//                    .clipShape(Circle())
//                    .padding(.horizontal)
//                    .padding(20)
//                    Button("Save") {
//                        arDelegate.stopRecording()
//                      //  recording.stopRecording()
//
//                    }
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
//                    .background(Color.orange)
//                    .foregroundColor(.white)
//                    .clipShape(Circle())
//                    .padding(.horizontal)
//                    .padding(20)
//                }
//            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
