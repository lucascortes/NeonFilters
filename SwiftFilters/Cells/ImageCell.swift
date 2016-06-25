//
//  ImageCell.swift
//  SwiftFilters
//
//  Created by Lucas Cortes on 12/24/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet private weak var cellImage: UIImageView!

    func configure(image: UIImage) {
        cellImage.image = image
    }

    class func identifier() -> String {
        return "ImageCell"
    }
}
