//
//  FilterCell.swift
//  SwiftFilters
//
//  Created by Lucas Cortes on 12/24/15.
//  Copyright © 2015. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet private weak var filterImage: UIImageView!
    @IBOutlet private weak var filterName: UILabel!

    func configure(filter: FilterType) {
        filterImage.image = filter.image
        filterName.text = filter.name
    }

    class func identifier() -> String {
        return "FilterCell"
    }
}
