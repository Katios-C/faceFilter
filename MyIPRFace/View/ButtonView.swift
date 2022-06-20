import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Text(startTitle)
        }
        .padding()
        .frame(width: 150, height: 50)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
    }
}
