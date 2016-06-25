//
//  ImageSelectionViewController.swift
//  SwiftFilters
//
//  Created by Lucas Cortes
//  Copyright © 2015. All rights reserved.
//

import UIKit

protocol ImageSelectionDelegate: class {
    func ImageSelection(imageSelectionVC: ImageSelectionViewController, didSelectImage image: UIImage)
}

class ImageSelectionViewController: UIViewController {

    //MARK: - Public properties

    weak var delegate: ImageSelectionDelegate?

    //MARK: - Private properties

    @IBOutlet private weak var collectionView: UICollectionView!
    private var images = [UIImage]()

    //MARK: - VC lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 1...8 {
            images.append(UIImage(named: "image\(i)")!)
        }

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }

    //MARK: - Private methods

    @IBAction private func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
}

extension ImageSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCell.identifier(), forIndexPath: indexPath) as! ImageCell
        cell.configure(images[indexPath.row])
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.ImageSelection(self, didSelectImage: images[indexPath.row])
        dismissViewControllerAnimated(true, completion: nil)
    }

}