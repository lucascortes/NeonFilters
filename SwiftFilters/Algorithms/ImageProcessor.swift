//
//  ImageProcessor.swift
//  SwiftFilters
//
//  Created by Lucas Cortes on 12/24/15.
//  Copyright © 2015. All rights reserved.
//

import Foundation
import UIKit

class ImageProcessor: NSObject {

    static func processImage(inputImage: UIImage, filter: FilterType) -> UIImage {
        let inputCGImage     = inputImage.CGImage
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = CGImageGetWidth(inputCGImage)
        let height           = CGImageGetHeight(inputCGImage)
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = CGImageAlphaInfo.PremultipliedLast.rawValue

        let originalContext = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)!
        CGContextDrawImage(originalContext, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), inputCGImage)

        let modifiedContext = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)!
        CGContextDrawImage(modifiedContext, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), inputCGImage)


        let originalPixelBuffer = UnsafeMutablePointer<UInt32>(CGBitmapContextGetData(originalContext))
        let modifiedPixelBuffer = UnsafeMutablePointer<UInt32>(CGBitmapContextGetData(modifiedContext))

        var currentOriginalPixel = originalPixelBuffer - 1      // (-1, 0)
        var currentModifiedPixel = modifiedPixelBuffer + width  // (0 , 1)

        let filterWidth = 3
        let filterHeight = 3

        let factor = Float(filter.factor.actual)
        let bias = Float(filter.bias.actual)

        for _ in 1..<(width * (height - 1)) {

            //multiply every value of the filter with corresponding image pixel
            var red: Float = 0.0, green: Float = 0.0, blue: Float = 0.0

            for filterY in 0..<filterHeight {
                for filterX in 0..<filterWidth {
                    red += Float(redC(currentOriginalPixel.memory)) * filter.matrix[filterX][filterY]
                    green += Float(greenC(currentOriginalPixel.memory)) * filter.matrix[filterX][filterY]
                    blue += Float(blueC(currentOriginalPixel.memory)) * filter.matrix[filterX][filterY]
                    currentOriginalPixel = currentOriginalPixel.successor()
                }
                currentOriginalPixel += width - 3
            }

            //truncate values smaller than zero and larger than 255

            let finalRed: UInt8 = UInt8(min(max(factor * red + bias, 0.0), 255.0))
            let finalGreen: UInt8 = UInt8(min(max(factor * green + bias, 0.0), 255.0))
            let finalBlue: UInt8 = UInt8(min(max(factor * blue + bias, 0.0), 255.0))

            currentModifiedPixel.memory = rgba(red: finalRed, green: finalGreen, blue: finalBlue, alpha: 255)

            currentModifiedPixel = currentModifiedPixel.successor()
            currentOriginalPixel -= 3 * width - 1
        }

        let outputCGImage = CGBitmapContextCreateImage(modifiedContext)!
        let outputImage = UIImage(CGImage: outputCGImage)

        return outputImage
    }


    //Helper functions

    static func redC(color: UInt32) -> UInt8 {
        return UInt8(color & 255)
    }

    static func greenC(color: UInt32) -> UInt8 {
        return UInt8((color >> 8) & 255)
    }
    
    static func blueC(color: UInt32) -> UInt8 {
        return UInt8((color >> 16) & 255)
    }
    
    static func alphaC(color: UInt32) -> UInt8 {
        return UInt8((color >> 24) & 255)
    }
    
    static func rgba(red red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
        return UInt32(red) | (UInt32(green) << 8) | (UInt32(blue) << 16) | (UInt32(alpha) << 24)
    }


}