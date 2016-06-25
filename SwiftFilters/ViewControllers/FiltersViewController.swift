//
//  ViewController.swift
//  asdf
//
//  Created by Lucas Cortes
//  Copyright © 2015. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var biasSlider: UISlider!
    @IBOutlet weak var factorSlider: UISlider!
    @IBOutlet weak var filtersCollectionView: UICollectionView!

    private var useNeon = true
    private let filters = Cassetes.DefaultFilter.all

    //MARK: - Private properties

    private var selectedFilter: FilterType = Cassetes.DefaultFilter.None() {
        didSet {
            biasSlider.value = selectedFilter.bias.actual
            biasSlider.minimumValue = selectedFilter.bias.min
            biasSlider.maximumValue = selectedFilter.bias.max

            factorSlider.value = selectedFilter.factor.actual
            factorSlider.minimumValue = selectedFilter.factor.min
            factorSlider.maximumValue = selectedFilter.factor.max

            applyActualFilter()
        }
    }

    private var image = UIImage(named: "image2")!

    //MARK: - VC lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self


        selectedFilter = Cassetes.DefaultFilter.None()
        applyActualFilter()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navigationVC = segue.destinationViewController as? UINavigationController,
        let imageSelector = navigationVC.viewControllers.first as? ImageSelectionViewController {
            imageSelector.delegate = self
        }
    }

    //MARK: - Private methods

    @IBAction private func biasSliderValueChanged(sender: AnyObject) {
        selectedFilter.bias.actual = biasSlider.value
        applyActualFilter()
    }

    @IBAction private func factorSliderValueChanged(sender: AnyObject) {
        selectedFilter.factor.actual = factorSlider.value
        applyActualFilter()
    }

    @IBAction func neonSwitcherValueChanged(sender: UISwitch) {
        useNeon = sender.on
    }

    private func applyActualFilter() {
        let result: UIImage
        if useNeon {
            result = ImageProcessor.processImageWithNEON(image, filter: selectedFilter)
        } else {
            result = ImageProcessor.processImage(image, filter: selectedFilter)
        }
        mainImage.image = result
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

extension FiltersViewController: ImageSelectionDelegate {
    func ImageSelection(imageSelectionVC: ImageSelectionViewController, didSelectImage image: UIImage) {
        self.image = image
        applyActualFilter()
    }
}

extension FiltersViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FilterCell.identifier(), forIndexPath: indexPath) as! FilterCell
        cell.configure(filters[indexPath.row])
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedFilter = filters[indexPath.row]
    }

}

