//
//  ImageProcessorExtension.swift
//  SwiftFilters
//
//  Created by Lucas Cortes on 12/24/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

extension ImageProcessor {

    static func processImageWithNEON(inputImage: UIImage, filter: FilterType) -> UIImage {
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

        let currentOriginalPixel = originalPixelBuffer - 1      // (-1, 0)
        let currentModifiedPixel = modifiedPixelBuffer + width  // (0 , 1)

        let filterWidth = 3
        let filterHeight = 3

        let factor = Float(filter.factor.actual)
        let bias = Float(filter.bias.actual)

        // Convert Swift matrix to C array
        let matrixElementsQty = filterWidth * filterHeight
        let cArray = UnsafeMutablePointer<Float>.alloc(matrixElementsQty)
        for i in 0..<filterHeight {
            for j in 0..<filterWidth {
                cArray[i*3 + j] = filter.matrix[i][j]
            }
        }

        //Asm call
        processPixel(cArray, currentOriginalPixel, currentModifiedPixel, factor, bias, Int32(width * bytesPerPixel), Int32(width * (height - 2)), Int32(bytesPerPixel))

        //Clean up C memory
        cArray.dealloc(matrixElementsQty)

        //Return image
        let outputCGImage = CGBitmapContextCreateImage(modifiedContext)!
        let outputImage = UIImage(CGImage: outputCGImage)
        
        return outputImage
    }

}