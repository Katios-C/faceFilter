import Foundation

class SelectSmileViewModel: ObservableObject {
  
    @Published  var selectedEyes = "⚽️"
    @Published  var selectedLips = "👄"
    @Published  var selectedNose = "💧"
    
    @Published var noseOptions = ["👃", "🐽", "💧", " "]
    @Published var eyeOptions = ["⚽️", "👁", "🌕", "🌟", "🔥", "🔎", " "]
    @Published var mouthOptions = [" ", "👄", "👅", "❤️", " "]
    
   // static var shared: SelectSmileViewModel = SelectSmileViewModel()
   
}
