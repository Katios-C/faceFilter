//
//import Foundation
//import SwiftUI
//import CoreMedia
//import AVFoundation
//import Photos
//
//class VideoRecotd {
//    var snapshotArray:[[String:Any]] = [[String:Any]]()
//    var lastTime:TimeInterval = 0
//    var isRecording:Bool = false;
//
//
//
//    // Button Functionality
//    func startRecording() {
//        self.lastTime = 0;
//        self.isRecording = true;
//    }
//        
//    func stopRecording() {
//        self.isRecording = false;
//        self.saveVideo(withName: "test", imageArray: self.snapshotArray, fps: 30, size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height));
//    }
//    
//    
//    public func didUpdateAtTime(time: TimeInterval) {
//        
//        if self.isRecording {
//            if self.lastTime == 0 || (self.lastTime + 1/31) < time {
//                DispatchQueue.main.async { [weak self] () -> Void in
//                    
//                    print("UPDATE AT TIME : \(time)");
//                    guard self != nil else { return }
//                    self!.lastTime = time;
//                    let snapshot:UIImage = self!.sceneView.snapshot()
//                    
//                    let scale = CMTimeScale(NSEC_PER_SEC)
//                    
//                    self!.snapshotArray.append([
//                        "image":snapshot,
//                        "time": CMTime(value: CMTimeValue((self?.sceneView.session.currentFrame!.timestamp)! * Double(scale)), timescale: scale)
//                    ]);
//                    
//                }
//            }
//        }
//    }
//    
//
//
//    var pixelBufferAdaptor:AVAssetWriterInputPixelBufferAdaptor?
//    var videoInput:AVAssetWriterInput?;
//    var assetWriter:AVAssetWriter?;
//
//
//    // MARK: SAVE VIDEO FUNCTIONALITY
//
//    public func saveVideo(withName:String, imageArray:[[String:Any]], fps:Int, size:CGSize) {
//            
//            self.createURLForVideo(withName: withName) { (videoURL) in
//                self.prepareWriterAndInput(imageArray:imageArray, size:size, videoURL: videoURL, completionHandler: { (error) in
//                    
//                    guard error == nil else {
//                        // it errored.
//                        return
//                    }
//                    
//                    self.createVideo(imageArray: imageArray, fps: fps, size:size, completionHandler: { _ in
//                        print("[F] saveVideo :: DONE");
//                        
//                        guard error == nil else {
//                            // it errored.
//                            return
//                        }
//                        
//                        self.finishVideoRecordingAndSave();
//                        
//                    });
//                });
//            }
//            
//        }
//        
//        private func createURLForVideo(withName:String, completionHandler:@escaping (URL)->()) {
//            // Clear the location for the temporary file.
//            let temporaryDirectoryURL:URL = URL.init(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true);
//            let targetURL:URL = temporaryDirectoryURL.appendingPathComponent("\(withName).mp4")
//            // Delete the file, incase it exists.
//            do {
//                try FileManager.default.removeItem(at: targetURL);
//                
//            } catch let error {
//                NSLog("Unable to delete file, with error: \(error)")
//            }
//            // return the URL
//            completionHandler(targetURL);
//        }
//        
//        private func prepareWriterAndInput(imageArray:[[String:Any]], size:CGSize, videoURL:URL, completionHandler:@escaping(Error?)->()) {
//            
//            do {
//                self.assetWriter = try AVAssetWriter(outputURL: videoURL, fileType: AVFileType.mp4)
//                
//                let videoOutputSettings: Dictionary<String, Any> = [
//                    AVVideoCodecKey : AVVideoCodecType.h264,
//                    AVVideoWidthKey : size.width,
//                    AVVideoHeightKey : size.height
//                ];
//        
//                self.videoInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoOutputSettings)
//                self.videoInput!.expectsMediaDataInRealTime = true
//                self.assetWriter!.add(self.videoInput!)
//                
//                // Create Pixel buffer Adaptor
//                
//                let sourceBufferAttributes:[String : Any] = [
//                    (kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32ARGB),
//                    (kCVPixelBufferWidthKey as String): Float(size.width),
//                    (kCVPixelBufferHeightKey as String): Float(size.height)] as [String : Any]
//                
//                self.pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: self.videoInput!, sourcePixelBufferAttributes: sourceBufferAttributes);
//        
//                self.assetWriter?.startWriting();
//                self.assetWriter?.startSession(atSourceTime: CMTime.zero);
//                completionHandler(nil);
//            }
//            catch {
//                print("Failed to create assetWritter with error : \(error)");
//                completionHandler(error);
//            }
//        }
//        
//        private func createVideo(imageArray:[[String:Any]], fps:Int, size:CGSize, completionHandler:@escaping(String?)->()) {
//            
//            var currentframeTime:CMTime = CMTime.zero;
//            var currentFrame:Int = 0;
//            
//            let startTime:CMTime = (imageArray[0])["time"] as! CMTime;
//            
//            while (currentFrame < imageArray.count) {
//                
//                // When the video input is ready for more media data...
//                if (self.videoInput?.isReadyForMoreMediaData)!  {
//                    print("processing current frame :: \(currentFrame)");
//                    // Get current CG Image
//                    let currentImage:UIImage = (imageArray[currentFrame])["image"] as! UIImage;
//                    let currentCGImage:CGImage? = currentImage.cgImage;
//                    
//                    guard currentCGImage != nil else {
//                        completionHandler("failed to get current cg image");
//                        return
//                    }
//                    
//                    // Create the pixel buffer
//                    self.createPixelBufferFromUIImage(image: currentImage) { (error, pixelBuffer) in
//                        
//                        guard error == nil else {
//                            completionHandler("failed to get pixelBuffer");
//                            return
//                        }
//                        
//                        // Calc the current frame time
//                        currentframeTime = (imageArray[currentFrame])["time"] as! CMTime - startTime;
//                        
//                        print("SECONDS : \(currentframeTime.seconds)")
//                        
//                        print("Current frame time :: \(currentframeTime)");
//                        
//                        // Add pixel buffer to video input
//                        self.pixelBufferAdaptor!.append(pixelBuffer!, withPresentationTime: currentframeTime);
//                        
//                        // increment frame
//                        currentFrame += 1;
//                    }
//                }
//            }
//            
//            // FINISHED
//            completionHandler(nil);
//        }
//        
//        
//        private func createPixelBufferFromUIImage(image:UIImage, completionHandler:@escaping(String?, CVPixelBuffer?) -> ()) {
//            //https://stackoverflow.com/questions/44400741/convert-image-to-cvpixelbuffer-for-machine-learning-swift
//            let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
//            var pixelBuffer : CVPixelBuffer?
//            let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
//            guard (status == kCVReturnSuccess) else {
//                completionHandler("Failed to create pixel buffer", nil)
//                return
//            }
//            
//            CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
//            
//            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
//            let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
//            
//            context?.translateBy(x: 0, y: image.size.height)
//            context?.scaleBy(x: 1.0, y: -1.0)
//            
//            UIGraphicsPushContext(context!)
//            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
//            UIGraphicsPopContext()
//            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
//            
//            completionHandler(nil, pixelBuffer)
//        }
//        
//        
//        private func finishVideoRecordingAndSave() {
//            self.videoInput!.markAsFinished();
//            self.assetWriter?.finishWriting(completionHandler: {
//                print("output url : \(self.assetWriter?.outputURL)");
//                
//                PHPhotoLibrary.requestAuthorization({ (status) in
//                    PHPhotoLibrary.shared().performChanges({
//                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: (self.assetWriter?.outputURL)!)
//                    }) { saved, error in
//                        
//                        if saved {
//                            let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
//                            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                            alertController.addAction(defaultAction)
//                           // self.present(alertController, animated: true, completion: nil)
//                        }
//                        // Clear the original array
//                        self.snapshotArray.removeAll();
//                        // Clear memory
//                     //   FileManager.default.clearTempMemory();
//                    }
//                })
//            })
//        }
//}
