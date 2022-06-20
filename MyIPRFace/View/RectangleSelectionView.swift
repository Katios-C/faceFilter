
import SwiftUI

struct RectangleSelectionView: View {
    @Binding var selectedE: String
    @Binding var selectedL: String
    @Binding var selectedN: String
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 300, height: 200)
                .foregroundColor(.gray)
                .opacity(0.3)
                .cornerRadius(15)
            VStack(){
                HStack() {
                    Text(selectEyesString)
                    
                    Picker(eyesString, selection:  $selectedE) {
                        ForEach(eyeOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .border(selectedE  == " " ? .white : .clear)
                    .pickerStyle(MenuPickerStyle())
                }
                
                
                HStack{
                    Text(selectedLipsString)
                    Picker(lipsString, selection: $selectedL) {
                        ForEach(mouthOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .border(selectedL == " " ? .white : .clear)
                    .pickerStyle(MenuPickerStyle())
                }
                
                HStack{
                    Text(selectedNoseString)
                    Picker(noseString, selection: $selectedN) {
                        ForEach(noseOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .border(selectedN  == " " ? .white : .clear)
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .padding()
        }
    }
}
