import SwiftUI
import ReplayKit
import UIKit
import XCTest
import ModelIO

extension View {
    func startRecording(enableMicrophone: Bool = false, completion: @escaping (Error?)->()){
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = false
        recorder.startRecording(handler: completion)
    }
    func stopRecording()async throws->URL {
        let name = UUID().uuidString + ".mov"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        let recorder = RPScreenRecorder.shared()
        try await recorder.stopRecording(withOutput: url)
        return url
    }
    
    func cancelRecording(){
        let recorder = RPScreenRecorder.shared()
        recorder.discardRecording {}
    }
    
    func shareSheet(show: Binding<Bool>, items: [Any?])-> some View {
        return self
            .sheet(isPresented: show){
                
            } content: {
                let items = items.compactMap{item -> Any? in
                    return item
                    
                }
                if !items.isEmpty{
                    ShareSheet(items: items)
                }
            }
    }

}

extension String {
    
    func image() -> UIImage? {
        
        let size = CGSize(width: 20, height: 22)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 15)])
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
