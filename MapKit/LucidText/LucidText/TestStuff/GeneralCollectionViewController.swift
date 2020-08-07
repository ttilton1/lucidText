//
//  CollectionViewController.swift
//  SelfSizing
//
//  Created by Tibor Bodecs on 04/08/16.
//  Copyright © 2016 Tibor Bodecs. All rights reserved.
//

import UIKit

class GeneralCollectionViewController: UICollectionViewController {
    
    var twoColumns = false
    
    var dataSource: [String] = [
        "Hello", "Word2"
    ]
}

extension GeneralCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                 target: self,
                                                                 action: #selector(self.toggleColumns))

        self.collectionView?.register(GeneralCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 64, height: 64)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 20
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            flowLayout.estimatedItemSize = CGSize(width: self.preferredWith(forSize: self.view.bounds.size), height: 64)
        }

        self.collectionView?.reloadData()

        NotificationCenter.default.addObserver(self.collectionView!,
                                               selector: #selector(UICollectionView.reloadData),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard
            let previousTraitCollection = previousTraitCollection,
            self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ||
            self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass
        else {
            return
        }
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.estimateVisibleCellSizes(to: size)
        
        coordinator.animate(alongsideTransition: { context in
            
        }, completion: { context in
            self.collectionView?.collectionViewLayout.invalidateLayout()
        })
    }

}

extension GeneralCollectionViewController {

    @objc func toggleColumns() {
        self.twoColumns = !self.twoColumns

        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
    }

    func preferredWith(forSize size: CGSize) -> CGFloat {
        var columnFactor: CGFloat = 1.0
        if self.twoColumns {
            columnFactor = 2.0
        }
        return (size.width - 30) / columnFactor
    }

    func estimateVisibleCellSizes(to size: CGSize) {
        guard let collectionView = self.collectionView else {
            return
        }
        
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: self.preferredWith(forSize: size), height: 64)
        }
        
        collectionView.visibleCells.forEach({ cell in
            if let cell = cell as? GeneralCollectionViewCell {
                cell.setPreferred(width: self.preferredWith(forSize: size))
            }
        })
    }
}

extension GeneralCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as! GeneralCollectionViewCell
        
        cell.setPreferred(width: self.preferredWith(forSize: collectionView.frame.size))

        cell.dynamicLabel?.text = self.dataSource[indexPath.row]
        
        return cell
    }
    
}
