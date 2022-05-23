import SwiftUI

struct ContentView: View {
    
    @ObservedObject var arDelegate = ARDelegate()
    
    var body: some View {
        ZStack {
            ARViewRepresentable(arDelegate: arDelegate)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
