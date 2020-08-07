//
//  WordsCollectionViewController.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/1/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import Foundation

import UIKit

final class WordsCollectionViewController: UICollectionViewController {

    //Properties
    private let reuseIdentifier = "Cell"
    
    private var libraryWords: [String] = [
        "Donec id elit non mi porta gravida at eget metus.",
        "Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
        "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Vestibulum id ligula porta felis euismod semper. Nullam id dolor id nibh ultricies vehicula ut id elit. Nullam quis risus eget urna mollis ornare vel eu leo.",
        "Maecenas faucibus mollis interdum.",
        "Donec ullamcorper nulla non metus auctor fringilla. Aenean lacinia bibendum nulla sed consectetur. Cras mattis consectetur purus sit amet fermentum.",
        "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Maecenas faucibus mollis interdum.",
        "Donec id elit non mi porta gravida at eget metus.",
        "Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
        "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Vestibulum id ligula porta felis euismod semper. Nullam id dolor id nibh ultricies vehicula ut id elit. Nullam quis risus eget urna mollis ornare vel eu leo.",
        "Maecenas faucibus mollis interdum.",
        "Donec ullamcorper nulla non metus auctor fringilla. Aenean lacinia bibendum nulla sed consectetur. Cras mattis consectetur purus sit amet fermentum.",
        "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Maecenas faucibus mollis interdum.",
    ]
    
    private let itemsPerRow: CGFloat = 0
    
    var twoColumns = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                        target: self,
                                                                        action: #selector(self.toggleColumns))
        
       self.collectionView?.register(WordViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
     if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 64, height: 64)
            flowLayout.minimumInteritemSpacing = 10
            flowLayout.minimumLineSpacing = 20
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            flowLayout.estimatedItemSize = CGSize(width: self.preferredWith(forSize: self.view.bounds.size), height: 64)
        }
        
       self.collectionView?.reloadData()
        //if screen frame switches update view
       NotificationCenter.default.addObserver(self.collectionView!,
                                              selector: #selector(UICollectionView.reloadData),
                                              name: UIContentSizeCategory.didChangeNotification,
                                              object: nil)

    }
    
    //NOTE((((((((((((((((((((((((((((((((((((((
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
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.libraryWords.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! WordViewCell
        
        cell.setPreferred(width: self.preferredWith(forSize: collectionView.frame.size))

        cell.name?.text = self.libraryWords[indexPath.row]
        
        return cell
    }
    
} //LAST BRACKET

extension WordsCollectionViewController {

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
            if let cell = cell as? WordViewCell {
                cell.setPreferred(width: self.preferredWith(forSize: size))
            }
        })
    }
}




