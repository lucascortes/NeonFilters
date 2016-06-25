//
//  SwiftFiltersTests.swift
//  SwiftFiltersTests
//
//  Created by Lucas Cortes on 12/24/15.
//  Copyright © 2015. All rights reserved.
//

import XCTest
@testable import SwiftFilters

class SwiftFiltersTestss: XCTestCase {

    let filter = Cassetes.DefaultFilter.FindEdges()
    let image = UIImage(named: "image2")!

    func testNEONPerformance() {

        self.measureBlock {
            ImageProcessor.processImageWithNEON(self.image, filter: self.filter)
        }
    }

    func testSwiftPerformance() {

        self.measureBlock {
            ImageProcessor.processImage(self.image, filter: self.filter)
        }
    }
    
}