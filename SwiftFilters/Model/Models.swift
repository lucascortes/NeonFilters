//
//  Models.swift
//  SwiftFilters
//
//  Created by Lucas Cortes on 12/24/15.
//  Copyright © 2015. All rights reserved.
//

import Foundation
import UIKit

typealias filterParameter = (initial: Float, actual: Float, min: Float, max: Float)

protocol FilterType {
    var name: String { get }
    var image: UIImage { get }
    var bias: filterParameter { get set }
    var factor: filterParameter { get set }
    var matrix: [[Float]] { get }
}

struct Cassetes {

    struct DefaultFilter {

        static var all: [FilterType] = [None(), Blur(), FindEdges(), Sharpen(), Emboss()]
        
        struct None: FilterType {
            let name = "Original"
            let image = UIImage(named: "original")!
            var bias: filterParameter = (initial: 0, actual: 0, min: -255, max: 255)
            var factor: filterParameter = (initial: 1, actual: 1, min: 0, max: 5)
            let matrix: [[Float]] =
            [
                [ 0, 0, 0 ],
                [ 0, 1, 0 ],
                [ 0, 0, 0.0 ]
            ]
        }

        struct Blur: FilterType {
            let name = "Blur"
            let image = UIImage(named: "blur")!
            var bias: filterParameter = (initial: 0, actual: 0, min: -255, max: 255)
            var factor: filterParameter = (initial: 1, actual: 1, min: 0, max: 5)
            let matrix: [[Float]] =
            [
                [0.0, 0.2,  0.0],
                [0.2, 0.2,  0.2],
                [0.0, 0.2,  0.0]
            ]
        }

        struct FindEdges: FilterType {
            let name = "Find Edges"
            let image = UIImage(named: "findEdges")!
            var bias: filterParameter = (initial: 0, actual: 0, min: -255, max: 255)
            var factor: filterParameter = (initial: 1, actual: 1, min: 0, max: 5)
            let matrix: [[Float]] =
            [
                [-1, -1, -1],
                [-1,  8, -1],
                [-1, -1, -1.0]
            ]
        }

        struct Sharpen: FilterType {
            let name = "Sharpen"
            let image = UIImage(named: "sharpen")!
            var bias: filterParameter = (initial: 0, actual: 0, min: -255, max: 255)
            var factor: filterParameter = (initial: 1, actual: 1, min: 0, max: 5)
            let matrix: [[Float]] =
            [
                [-1, -1, -1],
                [-1,  9, -1],
                [-1, -1, -1.0]
            ]
        }

        struct Emboss: FilterType {
            let name = "Emboss"
            let image = UIImage(named: "emboss")!
            var bias: filterParameter = (initial: 128, actual: 128, min: -255, max: 255)
            var factor: filterParameter = (initial: 1, actual: 1, min: 0, max: 5)
            let matrix: [[Float]] =
            [
                [-1, -1,  0],
                [-1,  0,  1],
                [ 0,  1,  1.0]
            ]
        }

    }
}
