//import Foundation
//import Photos
//import SwiftUI
//import ARKit
//
//
//class Recording: NSObject, ARSCNViewDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, ObservableObject  {
//// Recording
//    
//private var arView: ARSCNView?
//    
//private var isRecording:Bool = false;
//var snapshotArray:[[String:Any]] = [[String:Any]]()
//var lastTime:TimeInterval = 0
//private var videoStartTime:CMTime?;
//
//// Asset Writer
//var pixelBufferAdaptor:AVAssetWriterInputPixelBufferAdaptor?
//var videoInput:AVAssetWriterInput?;
//var audioInput:AVAssetWriterInput?;
//var assetWriter:AVAssetWriter?;
//
//// Audio
//var captureSession: AVCaptureSession?
//var micInput:AVCaptureDeviceInput?
//var audioOutput:AVCaptureAudioDataOutput?
//
//
//// Button Functionality
//func startRecording() {
//    
//    self.createURLForVideo(withName: "test") { (videoURL) in
//        self.prepareWriterAndInput(size:CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), videoURL: videoURL, completionHandler: { (error) in
//            
//            guard error == nil else {
//                // it errored.
//                return
//            }
//            self.startAudioRecording { (result) in
//                
//                guard result == true else {
//                    print("FAILED TO START AUDIO SESSION")
//                    return
//                }
//                
//                self.lastTime = 0;
//                self.isRecording = true;
//                self.didUpdateAtTime(time: self.lastTime)
//            }
//        });
//    };
//}
//
//func stopRecording() {
//    self.isRecording = false;
//    self.endAudioRecording()
//    self.finishVideoRecordingAndSave();
//}
//
//
////    func stopRecording() {
////        print("stopRecording")
////        self.isRecording = false;
////        self.saveVideo(withName: "test", imageArray: self.snapshotArray, fps: 30, size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height));
////    }
//
//
////  private var videoStartTime:CMTime?;
//
//public func didUpdateAtTime(time: TimeInterval) {
//    
//    if self.isRecording {
//        
//        if self.lastTime == 0 || (self.lastTime + 1/25) < time {
//            DispatchQueue.main.async { [weak self] () -> Void in
//                
//                let scale = CMTimeScale(NSEC_PER_SEC)
//                var currentFrameTime:CMTime = CMTime(value: CMTimeValue((self?.arView!.session.currentFrame!.timestamp)! * Double(scale)), timescale: scale);
//                
//                if self?.lastTime == 0 {
//                    self?.videoStartTime = currentFrameTime;
//                }
//                
//                print("UPDATE AT TIME : \(time)");
//                guard self != nil else { return }
//                self!.lastTime = time;
//                
//                // VIDEO
//                
//                self?.createPixelBufferFromUIImage(image: (self?.arView!.snapshot())!, completionHandler: { (error, pixelBuffer) in
//                    
//                    guard error == nil else {
//                        print("failed to get pixelBuffer");
//                        return
//                    }
//                    
//                    currentFrameTime = currentFrameTime - self!.videoStartTime!;
//                    
//                    // Add pixel buffer to video input
//                    self!.pixelBufferAdaptor!.append(pixelBuffer!, withPresentationTime: currentFrameTime);
//                    
//                });
//            }
//        }
//    }
//}
//
//
////    var pixelBufferAdaptor:AVAssetWriterInputPixelBufferAdaptor?
////    var videoInput:AVAssetWriterInput?;
////    var assetWriter:AVAssetWriter?;
//
//
//// MARK: SAVE VIDEO FUNCTIONALITY
//
//public func saveVideo(withName:String, imageArray:[[String:Any]], fps:Int, size:CGSize) {
//    print("sAVE VIDEO")
//    self.createURLForVideo(withName: withName) { (videoURL) in
//        self.prepareWriterAndInput( size:size, videoURL: videoURL, completionHandler: { (error) in
//            
//            guard error == nil else {
//                // it errored.
//                return
//            }
//            
//            self.createVideo(imageArray: imageArray, fps: fps, size:size, completionHandler: { _ in
//                print("[F] saveVideo :: DONE");
//                
//                guard error == nil else {
//                    // it errored.
//                    return
//                }
//                
//                self.finishVideoRecordingAndSave();
//                
//            });
//        });
//    }
//    
//}
//
//private func createURLForVideo(withName:String, completionHandler:@escaping (URL)->()) {
//    // Clear the location for the temporary file.
//    print("createURLForVideo")
//    let temporaryDirectoryURL:URL = URL.init(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true);
//    let targetURL:URL = temporaryDirectoryURL.appendingPathComponent("\(withName).mp4")
//    // Delete the file, incase it exists.
//    do {
//        try FileManager.default.removeItem(at: targetURL);
//        
//    } catch let error {
//        NSLog("Unable to delete file, with error: \(error)")
//    }
//    // return the URL
//    completionHandler(targetURL);
//}
//
//public func prepareWriterAndInput(size:CGSize, videoURL:URL, completionHandler:@escaping(Error?)->()) {
//    
//    do {
//        self.assetWriter = try AVAssetWriter(outputURL: videoURL, fileType: AVFileType.mp4)
//        
//        // Input is the mic audio of the AVAudioEngine
//        let audioOutputSettings = [
//            AVFormatIDKey : kAudioFormatMPEG4AAC,
//            AVNumberOfChannelsKey : 2,
//            AVSampleRateKey : 44100.0,
//            AVEncoderBitRateKey: 192000
//        ] as [String : Any]
//        
//        self.audioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioOutputSettings);
//        self.audioInput!.expectsMediaDataInRealTime = true
//        self.assetWriter?.add(self.audioInput!);
//        
//        //            self.audioInput.
//        
//        // Video Input Creator
//        
//        let videoOutputSettings: Dictionary<String, Any> = [
//            AVVideoCodecKey : AVVideoCodecType.h264,
//            AVVideoWidthKey : size.width,
//            AVVideoHeightKey : size.height
//        ];
//        
//        self.videoInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
//        self.videoInput!.expectsMediaDataInRealTime = true
//        self.assetWriter!.add(self.videoInput!)
//        
//        // Create Pixel buffer Adaptor
//        
//        let sourceBufferAttributes:[String : Any] = [
//            (kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32ARGB),
//            (kCVPixelBufferWidthKey as String): Float(size.width),
//            (kCVPixelBufferHeightKey as String): Float(size.height)] as [String : Any]
//        
//        self.pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: self.videoInput!, sourcePixelBufferAttributes: sourceBufferAttributes);
//        
//        self.assetWriter?.startWriting();
//        self.assetWriter?.startSession(atSourceTime: CMTime.zero);
//        completionHandler(nil);
//    }
//    catch {
//        print("Failed to create assetWritter with error : \(error)");
//        completionHandler(error);
//    }
//}
//
//private func createVideo(imageArray:[[String:Any]], fps:Int, size:CGSize, completionHandler:@escaping(String?)->()) {
//    print("Create video")
//    var currentframeTime:CMTime = CMTime.zero;
//    var currentFrame:Int = 0;
//    
//    let startTime:CMTime = (imageArray[0])["time"] as! CMTime;
//    
//    while (currentFrame < imageArray.count) {
//        
//        // When the video input is ready for more media data...
//        if (self.videoInput?.isReadyForMoreMediaData)!  {
//            print("processing current frame :: \(currentFrame)");
//            // Get current CG Image
//            let currentImage:UIImage = (imageArray[currentFrame])["image"] as! UIImage;
//            let currentCGImage:CGImage? = currentImage.cgImage;
//            
//            guard currentCGImage != nil else {
//                completionHandler("failed to get current cg image");
//                return
//            }
//            
//            // Create the pixel buffer
//            self.createPixelBufferFromUIImage(image: currentImage) { [self] (error, pixelBuffer) in
//                
//                guard error == nil else {
//                    completionHandler("failed to get pixelBuffer");
//                    return
//                }
//                
//                // Calc the current frame time
//                currentframeTime = (imageArray[currentFrame])["time"] as! CMTime - startTime;
//                
//                print("SECONDS : \(currentframeTime.seconds)")
//                
//                print("Current frame time :: \(currentframeTime)");
//                
//                // Add pixel buffer to video input
//                self.pixelBufferAdaptor!.append(pixelBuffer!, withPresentationTime: currentframeTime);
//                print("count")
//                
//                print(pixelBufferAdaptor?.accessibilityElementCount())
//                // increment frame
//                currentFrame += 1;
//            }
//        }
//    }
//    
//    // FINISHED
//    completionHandler(nil);
//}
//
//
//private func createPixelBufferFromUIImage(image:UIImage, completionHandler:@escaping(String?, CVPixelBuffer?) -> ()) {
//    print("createPixelBufferFromUIImage")
//    //https://stackoverflow.com/questions/44400741/convert-image-to-cvpixelbuffer-for-machine-learning-swift
//    let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
//    var pixelBuffer : CVPixelBuffer?
//    let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
//    guard (status == kCVReturnSuccess) else {
//        completionHandler("Failed to create pixel buffer", nil)
//        return
//    }
//    
//    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
//    
//    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
//    let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
//    
//    context?.translateBy(x: 0, y: image.size.height)
//    context?.scaleBy(x: 1.0, y: -1.0)
//    
//    UIGraphicsPushContext(context!)
//    image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
//    UIGraphicsPopContext()
//    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//    
//    completionHandler(nil, pixelBuffer)
//}
//
//
//private func finishVideoRecordingAndSave() {
//    print("finishVideoRecordingAndSave")
//    self.videoInput!.markAsFinished();
//    self.assetWriter?.finishWriting(completionHandler: {
//        print("output url : \(self.assetWriter?.outputURL)");
//        
//        PHPhotoLibrary.requestAuthorization({ (status) in
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: (self.assetWriter?.outputURL)!)
//            }) { saved, error in
//                
//                //                        if saved {
//                //                            let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
//                //                            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                //                            alertController.addAction(defaultAction)
//                //                           // self.present(alertController, animated: true, completion: nil)
//                //                        }
//                // Clear the original array
//                self.snapshotArray.removeAll();
//                // Clear memory
//                
//                // FileManager.default.clearTempMemory();
//            }
//        })
//    })
//}
//
//
//
//// MARK:  AUDIO FUNCTIONALITY
////        var captureSession: AVCaptureSession?
////        var micInput:AVCaptureDeviceInput?
////        var audioOutput:AVCaptureAudioDataOutput?
//
//
//func startAudioRecording(completionHandler:@escaping(Bool) -> ()) {
//    
//    let microphone = AVCaptureDevice.default(.builtInMicrophone, for: AVMediaType.audio, position: .unspecified)
//    
//    do {
//        try self.micInput = AVCaptureDeviceInput(device: microphone!);
//        
//        self.captureSession = AVCaptureSession();
//        
//        if (self.captureSession?.canAddInput(self.micInput!))! {
//            self.captureSession?.addInput(self.micInput!);
//            
//            self.audioOutput = AVCaptureAudioDataOutput();
//            
//            if self.captureSession!.canAddOutput(self.audioOutput!){
//                self.captureSession!.addOutput(self.audioOutput!)
//                self.audioOutput?.setSampleBufferDelegate(self, queue: DispatchQueue.global());
//                
//                self.captureSession?.startRunning();
//                completionHandler(true);
//            }
//            
//        }
//    }
//    catch {
//        completionHandler(false);
//    }
//}
//
//func endAudioRecording() { //completionHandler:@escaping()->()
//    
//    self.captureSession!.stopRunning();
//    print("snapshotArray.count")
//    print(snapshotArray.count)
//}
//
//func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//    
//    
//    // You now have the sample buffer - correct the timestamp to the video timestamp
//    
//    //https://github.com/takecian/video-examples-ios/blob/master/recordings/TimelapseCameraEngine.swift
//    
//    var count: CMItemCount = 0
//    CMSampleBufferGetSampleTimingInfoArray(sampleBuffer, entryCount: 0, arrayToFill: nil, entriesNeededOut: &count);
//    var info = [CMSampleTimingInfo](repeating: CMSampleTimingInfo(duration: CMTimeMake(value: 0, timescale: 0), presentationTimeStamp: CMTimeMake(value: 0, timescale: 0), decodeTimeStamp: CMTimeMake(value: 0, timescale: 0)), count: count)
//    CMSampleBufferGetSampleTimingInfoArray(sampleBuffer, entryCount: count, arrayToFill: &info, entriesNeededOut: &count);
//    
//    let scale = CMTimeScale(NSEC_PER_SEC)
//    var currentFrameTime:CMTime = CMTime(value: CMTimeValue((self.arView!.session.currentFrame!.timestamp) * Double(scale)), timescale: scale);
//    
//    currentFrameTime = currentFrameTime-self.videoStartTime!;
//    
//    for i in 0..<count {
//        info[i].decodeTimeStamp = currentFrameTime
//        info[i].presentationTimeStamp = currentFrameTime
//    }
//    
//    var soundbuffer:CMSampleBuffer?
//    
//    CMSampleBufferCreateCopyWithNewTiming(allocator: kCFAllocatorDefault, sampleBuffer: sampleBuffer, sampleTimingEntryCount: count, sampleTimingArray: &info, sampleBufferOut: &soundbuffer);
//    
//    
//    self.audioInput?.append(soundbuffer!);
//}
//}
