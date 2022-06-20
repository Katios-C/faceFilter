import SwiftUI
import Resolver
import iOSDevPackage

struct ARViewStart: View {
    @ObservedObject var arDelegate:ARDelegate = Resolver.resolve()
    @EnvironmentObject private var navigation: NavigationControllerViewModel
    
    
    @State var isRecording = false
    @State var url: URL?
    @State var shareVideo = false
    @Binding var eyeString: String
    @Binding var noseString: String
    @Binding var lipstring: String
    
    var body: some View {
        ZStack {
            ARViewRepresentable(arDelegate: arDelegate, eyeString: eyeString, noseString: noseString, lipsString: lipstring)
            
            VStack{
                Spacer()
                HStack{
                    Image(systemName: arrowBack)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            
                            if isRecording {
                                Task {
                                    do {
                                        self.url = try await stopRecording()
                                        isRecording = false
                                        shareVideo.toggle()
                                        navigation.pop(to: .previous)
                                    }
                                    catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            } else {
                                
                                navigation.pop(to: .previous)
                            }
                        }
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
                            Image(systemName: isRecording ? circleFill : recordCircle)
                                .font(.largeTitle)
                                .foregroundColor(isRecording ? .red : .black)
                        }
                }
                .padding(30)
                
            }
            .shareSheet(show: $shareVideo, items: [url])
        }
        .ignoresSafeArea()
    }
}

