//
//  WordViewCell.swift
//  LucidText
//
//  Created by Thomas Tilton on 4/7/20.
//  Copyright © 2020 Thomas Tilton. All rights reserved.
//

import UIKit

class WordViewCell: UICollectionViewCell {
    //Outlett
    weak var name: UILabel!
    
    //Label Presets
    var numOfLines = 0
    var backgroundLabelColor = UIColor.white
    var font = UIFont.preferredFont(forTextStyle: .body)
    
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
 //  required init?(coder aDecoder: NSCoder) {
  //      super.init(coder: aDecoder)
 //   }
        
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel(frame: self.bounds)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.backgroundColor = backgroundColor
        label.numberOfLines = numOfLines
        label.preferredMaxLayoutWidth = frame.size.width
        
        
        self.contentView.addSubview(label)
        self.name = label

        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.name.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.name.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.name.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.name.trailingAnchor),
        ])
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.name.font = font
    }

    func setPreferred(width: CGFloat) {
        self.name.preferredMaxLayoutWidth = width
    }
}
