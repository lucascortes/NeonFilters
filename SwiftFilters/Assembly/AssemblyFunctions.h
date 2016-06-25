//
//  AssemblyFunctions.h
//  SwiftFilters
//
//  Created by Lucas Cortes
//  Copyright © 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void processPixel(float *matrix, unsigned int *currentOriginalPixel, unsigned int *currentModifiedPixel, float factor, float bias, int imageWidth, int iterationAmount, int bytesPerPixel);