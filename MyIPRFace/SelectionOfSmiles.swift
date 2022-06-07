import SwiftUI
import Resolver
import iOSDevPackage

struct SelectionOfSmiles: View {
    
    @ObservedObject var selectSmile: SelectSmileViewModel = Resolver.resolve()
    @EnvironmentObject private var navigation: NavigationControllerViewModel
    
    // @Injected private var selectVM: SelectSmileViewModel
    //    let noseOptions = ["👃", "🐽", "💧", " "]
    //    let eyeOptions = ["⚽️", "👁", "🌕", "🌟", "🔥", "🔎", " "]
    //    let mouthOptions = [" ", "👄", "👅", "❤️", " "]
    //let hatOptions = ["🎓", "🎩", "🧢", "⛑", "👒", " "]
    
    //    @State private var selectedEyes = "⚽️"
    //    @State private var selectedLips = "👄"
    //    @State private var selectedNose = "💧"
    
    var body: some View {
        VStack {
            ZStack{
                Rectangle()
                    .frame(width: 300, height: 200)
                    .foregroundColor(.blue)
                    .cornerRadius(15)
                VStack(){
                    HStack() {
                        Text("Select eyes")
                        
                        Picker("Eyes", selection:  $selectSmile.selectedEyes) {
                            ForEach(selectSmile.eyeOptions, id: \.self) {
                                Text($0)
                                
                            }
                        }
                        .border(selectSmile.selectedEyes  == " " ? .white : .clear)
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    
                    HStack{
                        Text("Select lips")
                        Picker("Eyes", selection: $selectSmile.selectedLips) {
                            ForEach(selectSmile.mouthOptions, id: \.self) {
                                Text($0)
                            }
                            
                        }
                        .border(selectSmile.selectedLips == " " ? .white : .clear)
                        .pickerStyle(MenuPickerStyle())
                        
                    }
                    
                    HStack{
                        Text("Select nose")
                        Picker("Eyes", selection: $selectSmile.selectedNose) {
                            ForEach(selectSmile.noseOptions, id: \.self) {
                                Text($0)
                            }
                            
                        }
                        .border(selectSmile.selectedNose  == " " ? .white : .clear)
                        .pickerStyle(MenuPickerStyle())
                    }

                }
                .padding()
            }
            
            Button("Start") {
                navigation.push(ARViewStart(eyeString: selectSmile.selectedEyes, noseString: selectSmile.selectedNose, lipstring: selectSmile.selectedLips))
            }
            .padding()
            .frame(width: 150, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .onTapGesture {
                navigation.push(ARViewStart(eyeString: selectSmile.selectedEyes, noseString: selectSmile.selectedNose, lipstring: selectSmile.selectedLips))
            }
        }
        .padding()
    }
}

