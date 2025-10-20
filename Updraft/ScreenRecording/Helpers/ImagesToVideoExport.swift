//
//  ImagesToVideoExport.swift
//  Updraft
//
//  Created by Yanis Plumit on 15.09.2025.
//

import UIKit
import AVFoundation

extension URL {
    var pathSafe: String {
        if #available(iOS 16.0, *) {
            return self.path(percentEncoded: true)
        } else {
            return self.path
        }
    }
}

func createVideo(from imageUrls: [URL], size: CGSize, fps: Int = 30, outputURL: URL, completion: @escaping (Bool) -> Void) {
    guard !imageUrls.isEmpty else {
        completion(false);
        return
    }

    do {
        let writer = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
        let settings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.hevc,
            AVVideoWidthKey: size.width,
            AVVideoHeightKey: size.height
        ]
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
        input.expectsMediaDataInRealTime = false
        writer.add(input)

        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: nil)
        writer.startWriting()
        writer.startSession(atSourceTime: .zero)

        var frameCount: Int64 = 0
        let frameDuration = CMTime(value: 1, timescale: CMTimeScale(fps))

        for imageUrl in imageUrls {
            while !input.isReadyForMoreMediaData {
                Thread.sleep(forTimeInterval: 0.01)
            }
            
            let imagePath = imageUrl.pathSafe
            if var image = UIImage(contentsOfFile: imagePath) {
                if image.size.width != size.width, let fixedImage = image.rotated90CW() {
                    image = fixedImage
                }
                
                if let buffer = pixelBuffer(from: image) {
                    let time = CMTimeMultiply(frameDuration, multiplier: Int32(frameCount))
                    adaptor.append(buffer, withPresentationTime: time)
                    frameCount += 1
                }
            }
        }

        input.markAsFinished()
        writer.finishWriting {
            completion(writer.status == .completed)
        }
    } catch {
        print("Error AVAssetWriter: \(error)")
        completion(false)
    }
}

func pixelBuffer(from image: UIImage) -> CVPixelBuffer? {
    let attrs = [
        kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
        kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
    ] as CFDictionary

    var pixelBuffer: CVPixelBuffer?
    let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height),
                                     kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
    guard status == kCVReturnSuccess, let buffer = pixelBuffer else { return nil }

    CVPixelBufferLockBaseAddress(buffer, [])
    let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                            width: Int(image.size.width),
                            height: Int(image.size.height),
                            bitsPerComponent: 8,
                            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
    if let cgImage = image.cgImage {
        context?.draw(cgImage, in: CGRect(origin: .zero, size: image.size))
    }
    CVPixelBufferUnlockBaseAddress(buffer, [])
    return buffer
}

private extension UIImage {
    func rotated90CW() -> UIImage? {
        let radians: Float = .pi / 2
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        context.rotate(by: CGFloat(radians))
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
