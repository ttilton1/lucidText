//
//  CategoryCell.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/13/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit

private let sectionInsets = UIEdgeInsets(top: 0.0,
left: 20.0, //was 20
    bottom: 0.0, //was 50
right: 20.0)

private let inBetweenSpacing: CGFloat = 5

private let cellHeightText: CGFloat = 250
private let cellHeightWords: CGFloat = 120
private let headerHeight: CGFloat = 70

private let itemsPerRow: CGFloat = 1

class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "appCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        //self.ide
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not been implemented")
    }
    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    

    func setupViews() {
        backgroundColor = backgroundColor
        
        addSubview(appsCollectionView)
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hardWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AppCell else {
            fatalError("Unable to dequeue CellOne")
        }
     
        cell.textView.text = newDefs[indexPath.row]
        cell.nameLabel.text = hardWords[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: cellHeightWords)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return inBetweenSpacing
    }
}

class AppCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        //self.ide
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "HardWord"
            //sectionsArray[1][indexPath.row]
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.textColor = cellTextColor
        return label
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = sectionsArray[0][0]
        tv.sizeToFit()
        tv.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        tv.textColor = cellTextColor
        tv.isEditable = false
        return tv
    }()
    
    func setUpViews () {
        backgroundColor = backgroundColor
        addSubview(nameLabel)
        addSubview(textView)
         let widthTest = frame.width - 20
        // let heightTest = cell.frame.height
         let heightTest2 = frame.height * 0.25
         nameLabel.frame = CGRect(x: 10, y: 5, width: widthTest-10, height: heightTest2)
        let widthTestTwo = frame.width - 20
        let heightTestTwo = frame.height * 0.6
        textView.frame = CGRect(x: 10, y: 5 + heightTest2, width: widthTestTwo-10, height: heightTestTwo)
        self.layer.cornerRadius = cornerRadiusVar
        self.layer.borderWidth = cellBorderWidth
        self.layer.borderColor = cellBorderColor
        self.layer.backgroundColor = cellBackgroundColor
            
        
         
        
        
    }
}
